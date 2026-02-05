# Module - Oracle Container Instance  
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)[![OCI](https://img.shields.io/badge/provider-OCI-red)](https://registry.terraform.io/providers/oracle/oci/latest)

Module developed to standardize the creation of Oracle Cloud Infrastructure (OCI) Container Instances.

---

## Compatibility Matrix

| Module Version | Terraform Version | OCI Provider Version |
|----------------|------------------|---------------------|
| v1.0.0         | v1.14.4          | 8.0.0              |

---

## Specifying a Version

To avoid using the latest module version unintentionally, specify the `?ref=***` in the source URL to point to a specific version tag in the git repository.

---

## Use case

```hcl
module "container_instance" {
  source                  = "git::https://github.com/danilomnds/terraform-oci-container-instances?ref=v1.0.0"  
  availability_domain     = "YBIs:SA-VINHEDO-1-AD-1"
  fault_domain            = "FAULT-DOMAIN-1"
  compartment_id          = "<compartment_ocid>"   
  display_name            = "frontend"
  container_restart_policy = "ALWAYS"
  shape                   = "CI.Standard.E4.Flex"  
  tenancy_ocid = var.tenancy_ocid
  # Only on the first container it should be true!!!
  policies = true
  shape_config            = {
    ocpus         = 1
    memory_in_gbs = 4
  }
  containers = [{
    image_url = "vcp.ocir.io/namespace/path/path/path/servicedemo:1.0"
    display_name = "frontend-container"
    # Optional: add other container settings here
  }]
  vnics = {
    subnet_id = ""
    is_public_ip_assigned = false
    # Optional: add other VNIC settings here
  }  
  defined_tags = {
    "IT.area" : ""
    "IT.environment" : ""
    "IT.system" : ""
    "IT.deployedby" : "Terraform"
    "IT.provider" : ""
    "IT.region" : "sa-vinhedo-1"    
    "IT.department" : "ti"
    "IT.dl_owner" : ""
  }
  providers = {
    oci = oci
    oci.home = oci.home
  }
  groups = [
    "OracleIdentityCloudService/GRP_OCI****",
  ]
  compartment = ""  
}
```

### backend configuration
```hcl
terraform {
  backend "oci" {
    bucket    = "bucket name"
    namespace = " "
    key       = "repo/path/for/the/terraform.tfstate"           
    region = ""
  }
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "8.0.0"
    }
  }
}

provider "oci" {
  # if you are deploying on your home region, there is no need to specify the oci provider twice.  
  alias            = "home"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  # your home region
  region           = ""
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = ""
}
```


---

## Input variables

| Name                              | Description                                                                                 | Type           | Default   | Required |
|----------------------------------- |--------------------------------------------------------------------------------------------|----------------|-----------|:--------:|
| availability_domain                | The availability domain of the container instance                                          | `string`       | n/a       | Yes      |
| compartment_id                     | The OCID of the compartment in which to create the resource                                | `string`       | n/a       | Yes      |
| container_restart_policy           | Restart policy for the container instance (`Always`, `Never`, etc.)                        | `string`       | `"Always"`| No       |
| containers                         | Container configuration object (see below for structure)                                   | `object`       | n/a       | Yes      |
| defined_tags                       | Defined tags for this resource                                                             | `map(string)`  | `null`    | No       |
| display_name                       | The display name for the container instance                                                | `string`       | n/a       | Yes      |
| dns_config                         | DNS configuration object                                                                   | `object`       | `null`    | No       |
| fault_domain                       | The fault domain for the container instance                                                | `string`       | `null`    | No       |
| graceful_shutdown_timeout_in_seconds| Timeout for graceful shutdown                                                             | `number`       | `null`    | No       |
| image_pull_secrets                 | Registry authentication object (see below for structure)                                   | `object`       | n/a       | Yes      |
| shape                              | The shape of the container instance                                                        | `string`       | n/a       | Yes      |
| shape_config                       | Shape configuration object (see below for structure)                                       | `object`       | n/a       | Yes      |
| vnics                              | VNIC configuration object (see below for structure)                                        | `object`       | n/a       | Yes      |
| volumes                            | List of volume configuration objects                                                       | `list(object)` | `null`    | No       |
| state                              | Desired state of the container instance                                                    | `string`       | `null`    | No       |
| groups                             | List of groups to grant access via IAM policy                                              | `list(string)` | `[]`      | No       |
| compartment                        | Compartment name for IAM policy creation                                                   | `string`       | `null`    | No       |
| tenancy_ocid                       | Tenancy OCID where the container instance will be created                                  | `string`       | n/a       | No       |
| policies                           | Should access policies and dynamic group be created? I you have more than one specify it once | `bool`         | `false`   | No       |

---

## Output variables

| Name         | Description                                  |
|--------------|----------------------------------------------|
| id           | The OCID of the container instance           |
| display_name | The display name of the container instance   |

---

## Documentation

Oracle Container Instance:  
[https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/container_instances_container_instance](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/container_instances_container_instance)
