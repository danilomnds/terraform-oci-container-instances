terraform {
  required_version = ">= 1.14.4"
  required_providers {
    oci = {
      source                = "oracle/oci"
      version               = ">=7.33.0"
      configuration_aliases = [oci.home]
    }
  }
}