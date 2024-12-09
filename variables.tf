###############################################################################
# Terraform Variable Definitions
###############################################################################
###########################################################
# VMware Cloud Credential and Settings Variables
###########################################################
variable "vcenter_cloud_credential_name" {
  description = "The name of the Cloud Credential within Rancher"
  type        = string
}

variable "vcenter_hostname" {
  description = "FQDN for the vCenter server"
  type        = string
}

variable "vcenter_port" {
  description = "vSphere Port for vCenter"
  type        = string
  default     = "443"
}

variable "vcenter_unverified_ssl" {
  description = "Whether you are going to allow unverified SSL certificates"
  type        = bool
  default     = false
}

variable "vcenter_username" {
  description = "Username to use for vSphere CPI / CSI"
  type        = string
  sensitive   = true
}

variable "vcenter_password" {
  description = "Password to use for vSphere CPI / CSI"
  type        = string
  sensitive   = true
}

variable "vcenter_datacenter" {
  description = "Datacenter to host new Node VMs"
  type        = string
}

variable "vcenter_datastore" {
  description = "Datastore to store new Node VMs"
  type        = string
}

variable "vcenter_cluster" {
  description = "Compute Cluster to run new Node VMs"
  type        = string
}

variable "vcenter_resource_pool" {
  description = "Resource Pool to run the Nodes"
  type        = string
}

variable "vcenter_folder" {
  description = "VM Folder to store new Node VMs"
  type        = string
}

variable "vcenter_network_name" {
  description = "Port Group name for new Node VMs"
  type        = string
}

variable "vcenter_template" {
  description = "Virtual Machine Template for new Node VMs"
  type        = string
}

variable "vcenter_datastore_url" {
  description = "URL to the Datastore used for vSphere CSI. From vCenter UI"
  type        = string
}

###########################################################
# RKE2 Variables
###########################################################
variable "rke2_cluster_name" {
  description = "Name of the Cluster within the Rancher UI and KUBECONFIG"
  type        = string
  default     = "provisioned-rke2"
}

variable "rke2_release_version" {
  description = "Release version for RKE2 (refer to https://github.com/rancher/rke2/releases)"
  type        = string
  default     = "v1.30.5+rke2r1"
}

variable "rke2_repo_base_baseurl" {
  description = "URL to the Yum/DNF Repository for the Rancher RKE2 Base Packages"
  type        = string
  default     = "https://rpm.rancher.io/rke2/latest/1.30/centos/9/x86_64"
}

variable "rke2_repo_common_baseurl" {
  description = "URL to the Yum/DNF Repository for the Rancher RKE2 Common Packages"
  type        = string
  default     = "https://rpm.rancher.io/rke2/latest/common/centos/9/noarch"
}

variable "rancher_gpg_key" {
  description = "URL to the Rancher RKE2 GPG RPM signing key"
  type        = string
  default     = "https://rpm.rancher.io/public.key"
}

variable "rke2_pod_security_admission_template" {
  description = "Name of the Pod Security Admission Template to use"
  type        = string
  default     = "rancher-restricted"
}

variable "rke2_nginx_ingress_disabled" {
  description = "Whether or not the included NGINX Ingress Controller is Enabled"
  type        = bool
}

variable "rke2_cni_provider" {
  description = "Which CNI provider to use in the cluster"
  type        = string
  default     = "canal"
}

variable "rke2_security_profile" {
  description = "Value for the Security Profile to use in the config.yaml file"
  type        = string
  default     = "cis"
}

variable "rke2_cloud_provider" {
  description = "Name of the Cloud Provider Interface for the nodes"
  type        = string
  default     = "rancher-vsphere"
}

variable "rke2_create_timeout" {
  description = "Timeout in seconds for creation of cluster resources"
  type        = string
  default     = "30m"
}

variable "rke2_update_timeout" {
  description = "Timeout in seconds for update of cluster resources"
  type        = string
  default     = "30m"
}

variable "rke2_delete_timeout" {
  description = "Timeout in seconds for deletion of cluster resources"
  type        = string
  default     = "30m"
}

#######################################
# Control Node Variables
#######################################
variable "rke2_cn_name_prefix" {
  description = "The pattern to generate machine config name."
  type        = string
  default     = ""
}

variable "rke2_cn_instances" {
  description = "Number of Control Nodes to provision"
  type        = number
  default     = 1
}

variable "rke2_cn_cpu_count" {
  description = "vSphere CPU number for RKE2 Node VM."
  type        = string
  default     = "4"
}

variable "rke2_cn_memory_size" {
  description = "vSphere size of memory for RKE2 Node VM (in MB)"
  type        = string
  default     = "12288"
}

variable "rke2_cn_disk_size" {
  description = "vSphere size of disk for RKE2 Node VM (in MB)"
  type        = string
  default     = "107520"
}

variable "rke2_cn_timeout" {
  description = "Duration in seconds before the graceful shutdown of the VM times out and the VM is destroyed"
  type        = string
  default     = "600"
}

variable "rke2_cn_cp_concurrency" {
  description = "How many control plane nodes should be upgraded at a time, 0 is infinite."
  type        = number
  default     = 1
}

variable "rke2_cn_cp_drain_enabled" {
  description = "If enabled is set to true, nodes will be drained before upgrade."
  type        = bool
  default     = false
}

variable "rke2_cn_cp_drain_force" {
  description = "If force is set to true, drain nodes even if there are standalone pods that are not managed by a ReplicationController, Job, or DaemonSet."
  type        = bool
  default     = false
}

variable "rke2_cn_cp_drain_ignore_daemon_sets" {
  description = "If ignore_daemon_sets is set to false, drain will not proceed if there are DaemonSet-managed pods."
  type        = bool
  default     = true
}

variable "rke2_cn_cp_drain_ignore_errors" {
  description = "If ignore_errors is set to true, errors that occurred between drain nodes in group are ignored."
  type        = bool
  default     = true
}

variable "rke2_cn_cp_drain_del_empty_dir" {
  description = "if delete_empty_dir_data is set to true, continue draining even if there are pods using emptyDir (local storage)."
  type        = bool
  default     = true
}

variable "rke2_cn_cp_drain_disable_eviction" {
  description = "If disable_eviction is set to true, force drain to use delete rather than evict."
  type        = bool
  default     = true
}

variable "rke2_cn_cp_drain_grace_period" {
  description = "Time in seconds given to each pod to terminate gracefully. If negative, the default value specified in the pod will be used."
  type        = number
  default     = -1
}

variable "rke2_cn_cp_drain_timeout" {
  description = "Time to wait (in seconds) before giving up for one try."
  type        = number
  default     = 300
}

variable "rke2_cn_cp_drain_skip_wait" {
  description = "Skip waiting for the pods that have a DeletionTimeStamp > N seconds to be deleted. Seconds must be greater than 0 to skip. Such pods will be force deleted."
  type        = number
  default     = 0
}

variable "rke2_cn_tags" {
  description = "vSphere Tags to apply to Control Nodes"
  type        = list(string)
  default     = []
}

variable "rke2_cn_annotations" {
  description = "Additional annotations for Control Nodes"
  type        = map(string)
  default     = {}
}

#######################################
# Worker Node Variables
#######################################
variable "rke2_wn_name_prefix" {
  description = "The pattern to generate machine config name."
  type        = string
  default     = ""
}

variable "rke2_wn_instances" {
  description = "Number of Worker (Agent) Nodes to provision"
  type        = number
  default     = 2
}

variable "rke2_wn_cpu_count" {
  description = "vSphere CPU number for RKE2 Node VM."
  type        = string
  default     = "4"
}

variable "rke2_wn_memory_size" {
  description = "vSphere size of memory for RKE2 Node VM (in MB)"
  type        = string
  default     = "16384"
}

variable "rke2_wn_disk_size" {
  description = "vSphere size of disk for RKE2 Node VM (in MB)"
  type        = string
  default     = "107520"
}

variable "rke2_wn_timeout" {
  description = "Duration in seconds before the graceful shutdown of the VM times out and the VM is destroyed"
  type        = string
  default     = "600"
}

variable "rke2_wn_cp_concurrency" {
  description = "How many worker nodes should be upgraded at a time, 0 is infinite."
  type        = number
  default     = 1
}

variable "rke2_wn_cp_drain_enabled" {
  description = "If enabled is set to true, nodes will be drained before upgrade."
  type        = bool
  default     = true
}

variable "rke2_wn_cp_drain_force" {
  description = "If force is set to true, drain nodes even if there are standalone pods that are not managed by a ReplicationController, Job, or DaemonSet."
  type        = bool
  default     = true
}

variable "rke2_wn_cp_drain_ignore_daemon_sets" {
  description = "If ignore_daemon_sets is set to false, drain will not proceed if there are DaemonSet-managed pods."
  type        = bool
  default     = true
}

variable "rke2_wn_cp_drain_ignore_errors" {
  description = "If ignore_errors is set to true, errors that occurred between drain nodes in group are ignored."
  type        = bool
  default     = true
}

variable "rke2_wn_cp_drain_del_empty_dir" {
  description = "if delete_empty_dir_data is set to true, continue draining even if there are pods using emptyDir (local storage)."
  type        = bool
  default     = true
}

variable "rke2_wn_cp_drain_disable_eviction" {
  description = "If disable_eviction is set to true, force drain to use delete rather than evict."
  type        = bool
  default     = true
}

variable "rke2_wn_cp_drain_grace_period" {
  description = "Time in seconds given to each pod to terminate gracefully. If negative, the default value specified in the pod will be used."
  type        = number
  default     = -1
}

variable "rke2_wn_cp_drain_timeout" {
  description = "Time to wait (in seconds) before giving up for one try."
  type        = number
  default     = 300
}

variable "rke2_wn_cp_drain_skip_wait" {
  description = "Skip waiting for the pods that have a DeletionTimeStamp > N seconds to be deleted. Seconds must be greater than 0 to skip. Such pods will be force deleted."
  type        = number
  default     = 0
}

variable "rke2_wn_tags" {
  description = "vSphere Tags to apply to Worker Nodes"
  type        = list(string)
  default     = []
}

variable "rke2_wn_annotations" {
  description = "Additional annotations for Worker Nodes"
  type        = map(string)
  default     = {}
}

###########################################################
# Admin Variables
###########################################################
variable "admin_username" {
  description = "Username value for the Admin User"
  type        = string
}

variable "admin_pw_encrypted" {
  description = "Encrypted password for the Admin User. This must be in bcrypt format"
  type        = string
}

variable "admin_public_key" {
  description = "OpenSSH Public Key for the Admin User"
  type        = string
}