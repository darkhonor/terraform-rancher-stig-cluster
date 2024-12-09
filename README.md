# Rancher vSphere STIG Cluster Terraform module

Terraform module which provisions a RKE2 or K3S cluster within Rancher that
complies with U.S. DoD Security Technical Implementation Guidance (STIG)
guidelines as defined [here]()
in a vSphere environment.

This module could be easily modified to support deployment to Azure, AWS,
or other Cloud Provider.

## Usage

```hcl
module "rke2_cluster" {
  source = ""

  name = ""
}
```

## Author Information

Alex Ackerman, @darkhonor
