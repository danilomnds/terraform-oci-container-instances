variable "availability_domain" {
  type = string
}

variable "compartment_id" {
  type = string
}

variable "container_restart_policy" {
  type    = string
  default = "Always"
}

variable "containers" {
  type = list(object({
    arguments             = optional(list(string))
    command               = optional(list(string))
    defined_tags          = optional(map(string))
    display_name          = optional(string)
    environment_variables = optional(map(string))
    health_checks = optional(list(object({
      failure_action    = optional(string)
      failure_threshold = optional(number)
      headers = optional(object({
        name  = string
        value = string
      }))
      health_check_type        = string
      initial_delay_in_seconds = optional(number)
      interval_in_seconds      = optional(number)
      name                     = optional(string)
      path                     = optional(string)
      port                     = number
      success_threshold        = optional(number)
      timeout_in_seconds       = optional(number)
    })))
    image_url                      = string
    is_resource_principal_disabled = optional(bool)
    resource_config = optional(object({
      memory_limit_in_gbs = optional(number)
      vcpus_limit         = optional(number)
    }))
    security_context = optional(object({
      capabilities = optional(object({
        add_capabilities  = optional(list(string))
        drop_capabilities = optional(list(string))
      }))
      is_non_root_user_check_enabled = optional(bool)
      is_root_file_system_readonly   = optional(bool)
      run_as_group                   = optional(number)
      run_as_user                    = optional(number)
      security_context_type          = optional(string)
    }))
    volume_mounts = optional(list(object({
      is_read_only = optional(bool)
      mount_path   = string
      partition    = optional(string)
      sub_path     = optional(string)
      volume_name  = string
    })))
    working_directory = optional(string)
  }))
}

variable "defined_tags" {
  type    = map(string)
  default = null
}

variable "display_name" {
  type = string
}

variable "dns_config" {
  type = object({
    nameservers = optional(string)
    options     = optional(list(string))
    searches    = optional(list(string))
  })
  default = null
}

variable "fault_domain" {
  type    = string
  default = null
}

variable "graceful_shutdown_timeout_in_seconds" {
  type    = number
  default = null
}

variable "image_pull_secrets" {
  type = object({
    password          = optional(string)
    registry_endpoint = string
    secret_id         = optional(string)
    secret_type       = string
    username          = optional(string)
  })
  default = null
}

variable "shape" {
  type = string
}

variable "shape_config" {
  type = object({
    memory_in_gbs = optional(number)
    ocpus         = number
  })
}

variable "vnics" {
  type = object({
    defined_tags           = optional(map(string))
    display_name           = optional(string)
    hostname_label         = optional(string)
    is_public_ip_assigned  = optional(bool)
    nsg_ids                = optional(list(string))
    private_ip             = optional(string)
    skip_source_dest_check = optional(bool)
    subnet_id              = string
  })
}

variable "volumes" {
  type = list(object({
    backing_store = optional(string)
    configs = optional(object({
      data      = optional(string)
      file_name = optional(string)
      path      = optional(string)
    }))
    name        = string
    volume_type = string
  }))
  default = null
}

variable "state" {
  type    = string
  default = null
}

variable "groups" {
  type    = list(string)
  default = []
}

variable "compartment" {
  type    = string
  default = null
}

variable "rbac" {
  type    = bool
  default = false
}

variable "tenancy_ocid" {
  type = string  
}

variable "policies" {
  type = bool
  default = false
}