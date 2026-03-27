terraform {
  required_version = ">= 1.14.8"
  required_providers {
    oci = {
      source                = "oracle/oci"
      version               = ">=8.7.0"
      configuration_aliases = [oci.home]
    }
  }
}