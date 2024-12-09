###############################################################################
# Resource Definition
###############################################################################
###########################################################
# Lookup Values
###########################################################
data "rancher2_cloud_credential" "vcenter" {
  name = var.vcenter_cloud_credential_name
}

###########################################################
# Cluster Config
###########################################################
resource "rancher2_cluster_v2" "rke2" {
  name               = var.rke2_cluster_name
  kubernetes_version = var.rke2_release_version
  local_auth_endpoint {
    enabled = false
  }
  enable_network_policy                                      = false
  default_cluster_role_for_project_members                   = "user"
  default_pod_security_admission_configuration_template_name = var.rke2_pod_security_admission_template
  rke_config {
    machine_global_config = templatefile("${path.module}/resources/config.tftpl", {
      cni_provider = var.rke2_cni_provider,
      disable_nginx = var.rke2_nginx_ingress_disabled
    })
#     machine_global_config = <<EOF
# cni: "${var.rke2_cni_provider}"
# secrets-encryption: true                ### Group ID: V-254573 STIG ID: CNTR-R2-001500
# write-kubeconfig-mode: 0600             ### Group ID: V-254564 STIG ID: CNTR-R2-000520
# ### Begin Group ID: V-254566 STIG ID: CNTR-R2-000580
# service-node-port-range: 30000-32767
# ### End Group ID: V-254566 STIG ID: CNTR-R2-000580
# kube-controller-manager-arg:
#   - bind-address=127.0.0.1                ### Group ID: V-254556 STIG ID: CNTR-R2-000100
#   - use-service-account-credentials=true  ### Group ID: V-254554 STIG ID: CNTR-R2-000030
#   - tls-min-version=VersionTLS12          ### Group ID: V-254553 STIG ID: CNTR-R2-000010
#   - tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384   ### Group ID: V-254553 STIG ID: CNTR-R2-000010
# kube-scheduler-arg:
#   - tls-min-version=VersionTLS12          ### Group ID: V-254553 STIG ID: CNTR-R2-000010
#   - tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384   ### Group ID: V-254553 STIG ID: CNTR-R2-000010
# kube-apiserver-arg:
#   - tls-min-version=VersionTLS12          ### Group ID: V-254553 STIG ID: CNTR-R2-000010
#   - tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384   ### Group ID: V-254553 STIG ID: CNTR-R2-000010
#   - authorization-mode=RBAC,Node          ### Group ID: V-254572 STIG ID: CNTR-R2-001270
#   - anonymous-auth=false                  ### Group ID: V-254562 STIG ID: CNTR-R2-000160
#   - audit-policy-file=/etc/rancher/rke2/audit-policy.yaml     ### Group ID: V-254555 STIG ID: CNTR-R2-000060
#   - audit-log-mode=blocking-strict                            ### Group ID: V-254555 STIG ID: CNTR-R2-000060
#   - audit-log-maxage=30                                       ### Group ID: V-254563 STIG ID: CNTR-R2-000320
#   - admission-control-config-file=/etc/rancher/rke2/config/rancher-psact.yaml     ### Group ID: V-254571 STIG ID: CNTR-R2-001130
# kubelet-arg:
#   - streaming-connection-idle-timeout=5m  ### Group ID: V-254568 STIG ID: CNTR-R2-000890
#   - protect-kernel-defaults=true          ### Group ID: V-254569 STIG ID: CNTR-R2-000940
#   - read-only-port=0                      ### Group ID: V-254559 STIG ID: CNTR-R2-000130
#   - authorization-mode=Webhook            ### Group ID: V-254561 STIG ID: CNTR-R2-000150
#   - anonymous-auth=false                  ### Group ID: V-254557 STIG ID: CNTR-R2-000110
# # disable:
# #   - rke2-ingress-nginx
# #   - rke2-metrics-server
# EOF
    machine_pools {
      name                         = var.rke2_cn_name_prefix
      cloud_credential_secret_name = data.rancher2_cloud_credential.vcenter.id
      control_plane_role           = true
      etcd_role                    = true
      worker_role                  = false
      quantity                     = var.rke2_cn_instances
      machine_config {
        kind = rancher2_machine_config_v2.cn.kind
        name = rancher2_machine_config_v2.cn.name
      }
      drain_before_delete = true
      annotations         = var.rke2_cn_annotations
    }
    machine_pools {
      name                         = var.rke2_wn_name_prefix
      cloud_credential_secret_name = data.rancher2_cloud_credential.vcenter.id
      control_plane_role           = false
      etcd_role                    = false
      worker_role                  = true
      quantity                     = var.rke2_wn_instances
      machine_config {
        kind = rancher2_machine_config_v2.wn.kind
        name = rancher2_machine_config_v2.wn.name
      }
      drain_before_delete = true
      annotations         = var.rke2_wn_annotations
    }
    upgrade_strategy {
      control_plane_concurrency = var.rke2_cn_cp_concurrency
      control_plane_drain_options {
        enabled                              = var.rke2_cn_cp_drain_enabled
        force                                = var.rke2_cn_cp_drain_force
        ignore_daemon_sets                   = var.rke2_cn_cp_drain_ignore_daemon_sets
        ignore_errors                        = var.rke2_cn_cp_drain_ignore_errors
        delete_empty_dir_data                = var.rke2_cn_cp_drain_del_empty_dir
        disable_eviction                     = var.rke2_cn_cp_drain_disable_eviction
        grace_period                         = var.rke2_cn_cp_drain_grace_period
        timeout                              = var.rke2_cn_cp_drain_timeout
        skip_wait_for_delete_timeout_seconds = var.rke2_cn_cp_drain_skip_wait
      }
      worker_concurrency = var.rke2_wn_cp_concurrency
      worker_drain_options {
        enabled                              = var.rke2_wn_cp_drain_enabled
        force                                = var.rke2_wn_cp_drain_force
        ignore_daemon_sets                   = var.rke2_wn_cp_drain_ignore_daemon_sets
        ignore_errors                        = var.rke2_wn_cp_drain_ignore_errors
        delete_empty_dir_data                = var.rke2_wn_cp_drain_del_empty_dir
        disable_eviction                     = var.rke2_wn_cp_drain_disable_eviction
        grace_period                         = var.rke2_wn_cp_drain_grace_period
        timeout                              = var.rke2_wn_cp_drain_timeout
        skip_wait_for_delete_timeout_seconds = var.rke2_wn_cp_drain_skip_wait
      }
    }
    # registries {
    #   mirrors {
    #     hostname  = "*"
    #     endpoints = ["${var.enclave_registry_protocol}://${var.enclave_default_registry}:${var.enclave_registry_port}"]
    #   }
    # }
    etcd {
      snapshot_schedule_cron = "0 */5 * * *"
      snapshot_retention     = 5
    }
    machine_selector_config {
      config = yamlencode({
        profile                 = "${var.rke2_security_profile}"
        cloud-provider-name     = "${var.rke2_cloud_provider}"
        protect-kernel-defaults = true
      })
    }
    chart_values = <<EOF
      rancher-vsphere-cpi:
        vCenter:
          host: "${var.vcenter_hostname}"
          port: ${var.vcenter_port}
          insecureFlag: ${var.vcenter_unverified_ssl}
          datacenters: "${var.vcenter_datacenter}"
          username: "${var.vcenter_username}"
          password: "${var.vcenter_password}"
          credentialsSecret:
            name: "vsphere-cpi-creds"
            generate: true
        cloudControllerManager:
          nodeSelector:
            node-role.kubernetes.io/control-plane: 'true'
          podAntiAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
              - labelSelector:
                  matchExpressions:
                    - key: app
                      operator: In
                      values:
                        - vsphere-csi-controller
                topologyKey: kubernetes.io/hostname
      rancher-vsphere-csi:
        vCenter:
          host: "${var.vcenter_hostname}"
          port: ${var.vcenter_port}
          insecureFlag: ${var.vcenter_unverified_ssl}
          datacenters: "${var.vcenter_datacenter}"
          username: "${var.vcenter_username}"
          password: "${var.vcenter_password}"
          configSecret:
            name: "vsphere-config-secret"
            generate: true
        csiNode:
          nodeSelector:
            node-role.kubernetes.io/worker: 'true'
        storageClass:
          allowVolumeExpansion: true
          datastoreURL: ${var.vcenter_datastore_url}
  EOF
  }

  timeouts {
    create = var.rke2_create_timeout
    update = var.rke2_update_timeout
    delete = var.rke2_delete_timeout
  }
}

###########################################################
# Machine Config
###########################################################
resource "rancher2_machine_config_v2" "cn" {
  generate_name = "cn-config"
  vsphere_config {
    vcenter       = var.vcenter_hostname
    datacenter    = "/${var.vcenter_datacenter}"
    datastore     = "/${var.vcenter_datacenter}/datastore/${var.vcenter_datastore}"
    folder        = "/${var.vcenter_datacenter}/vm/${var.vcenter_folder}"
    pool          = "/${var.vcenter_datacenter}/host/${var.vcenter_cluster}/Resources/${var.vcenter_resource_pool}"
    network       = ["/${var.vcenter_datacenter}/network/${var.vcenter_network_name}"]
    creation_type = "template"
    clone_from    = "/${var.vcenter_datacenter}/vm/${var.vcenter_template}"
    cpu_count     = var.rke2_cn_cpu_count
    memory_size   = var.rke2_cn_memory_size
    disk_size     = var.rke2_cn_disk_size
    cfgparam      = ["disk.enableUUID=true"]
    cloud_config = templatefile("${path.module}/resources/cloudinit-cn.tftpl", {
      admin_username       = var.admin_username,
      admin_pw_encrypted   = var.admin_pw_encrypted,
      admin_ssh_public_key = var.admin_public_key,
      rke2_base_baseurl    = var.rke2_repo_base_baseurl,
      rke2_common_baseurl  = var.rke2_repo_common_baseurl,
      rancher_gpg_key      = var.rancher_gpg_key
    })
    graceful_shutdown_timeout = "0"
    tags                      = var.rke2_cn_tags
  }
}

resource "rancher2_machine_config_v2" "wn" {
  generate_name = "wn-config"
  vsphere_config {
    vcenter       = var.vcenter_hostname
    datacenter    = "/${var.vcenter_datacenter}"
    datastore     = "/${var.vcenter_datacenter}/datastore/${var.vcenter_datastore}"
    folder        = "/${var.vcenter_datacenter}/vm/${var.vcenter_folder}"
    pool          = "/${var.vcenter_datacenter}/host/${var.vcenter_cluster}/Resources/${var.vcenter_resource_pool}"
    network       = ["/${var.vcenter_datacenter}/network/${var.vcenter_network_name}"]
    creation_type = "template"
    clone_from    = "/${var.vcenter_datacenter}/vm/${var.vcenter_template}"
    cpu_count     = var.rke2_wn_cpu_count
    memory_size   = var.rke2_wn_memory_size
    disk_size     = var.rke2_wn_disk_size
    cfgparam      = ["disk.enableUUID=true"]
    cloud_config = templatefile("${path.module}/resources/cloudinit-wn.tftpl", {
      rke2_base_baseurl   = var.rke2_repo_base_baseurl,
      rke2_common_baseurl = var.rke2_repo_common_baseurl,
      rancher_gpg_key     = var.rancher_gpg_key
    })
    graceful_shutdown_timeout = "0"
    tags                      = var.rke2_wn_tags
  }
}
