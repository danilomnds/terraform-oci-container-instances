resource "oci_identity_dynamic_group" "dg_container_instances" {
  provider       = oci.home  
  count          = var.policies ? 1 : 0
  compartment_id = var.tenancy_ocid
  description    = "Dynamic group used by Container Instance"  
  matching_rule  = "ALL {resource.type='computecontainerinstance', resource.compartment.id = '${var.compartment_id}'}"
  name           = "dg_container_instances"
}

resource "oci_identity_policy" "policy_dg_container_instances" {
  provider       = oci.home
  depends_on     = [oci_identity_dynamic_group.dg_container_instances]
  count          = var.policies ? 1 : 0
  compartment_id = var.compartment_id
  name           = "policy_dg_container_instances"
  description    = "allow dg_container_instances pull images from container repository"
  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_container_instances[0].name} to read repos in compartment ${var.compartment}" 
  ]  
}

resource "oci_container_instances_container_instance" "instance" {
  depends_on = [ oci_identity_policy.policy_dg_container_instances ]
  availability_domain      = var.availability_domain
  compartment_id           = var.compartment_id
  container_restart_policy = var.container_restart_policy
  containers {
    arguments             = lookup(var.containers[0], "arguments", null)
    command               = lookup(var.containers[0], "command", null)
    defined_tags          = lookup(var.containers[0], "defined_tags", local.default_tags)
    display_name          = lookup(var.containers[0], "display_name", null)
    environment_variables = lookup(var.containers[0], "environment_variables", null)
    dynamic "health_checks" {
      for_each = var.containers[0].health_checks != null ? var.containers[0].health_checks : []
      content {
        failure_action    = optional(health_checks.value.failure_action, null)
        failure_threshold = optional(health_checks.value.failure_threshold, null)
        dynamic "headers" {
          for_each = health_checks.value.headers != null ? [health_checks.value.headers] : []
          content {
            name  = headers.value.name
            value = headers.value.value
          }
        }
        health_check_type        = health_checks.value.health_check_type
        initial_delay_in_seconds = optional(health_checks.value.initial_delay_in_seconds, null)
        interval_in_seconds      = optional(health_checks.value.interval_in_seconds, null)
        name                     = optional(health_checks.value.name, null)
        path                     = optional(health_checks.value.path, null)
        port                     = health_checks.value.port
        success_threshold        = optional(health_checks.value.success_threshold, null)
        timeout_in_seconds       = optional(health_checks.value.timeout_in_seconds, null)
      }
    }
    image_url                      = var.containers[0].image_url
    is_resource_principal_disabled = lookup(var.containers[0], "is_resource_principal_disabled", null)
    dynamic "resource_config" {
      for_each = var.containers[0].resource_config != null ? [var.containers[0].resource_config] : []
      content {
        memory_limit_in_gbs = lookup(resource_config.value, "memory_limit_in_gbs", null)
        vcpus_limit         = lookup(resource_config.value, "vcpus_limit", null)
      }
    }
    dynamic "security_context" {
      for_each = var.containers[0].security_context != null ? [var.containers[0].security_context] : []
      content {
        dynamic "capabilities" {
          for_each = security_context.value.capabilities != null ? [security_context.value.capabilities] : []
          content {
            add_capabilities  = lookup(capabilities.value, "add_capabilities", null)
            drop_capabilities = lookup(capabilities.value, "drop_capabilities", null)
          }
        }
        is_non_root_user_check_enabled = lookup(security_context.value, "is_non_root_user_check_enabled", null)
        is_root_file_system_readonly   = lookup(security_context.value, "is_root_file_system_readonly", null)
        run_as_group                   = lookup(security_context.value, "run_as_group", null)
        run_as_user                    = lookup(security_context.value, "run_as_user", null)
        security_context_type          = lookup(security_context.value, "security_context_type", null)
      }
    }
    dynamic "volume_mounts" {
      for_each = var.containers[0].volume_mounts != null ? var.containers[0].volume_mounts : []
      content {
        is_read_only = lookup(volume_mounts.value, "is_read_only", null)
        mount_path   = volume_mounts.value.mount_path
        partition    = lookup(volume_mounts.value, "partition", null)
        sub_path     = lookup(volume_mounts.value, "sub_path", null)
        volume_name  = volume_mounts.value.volume_name
      }
    }
    working_directory = lookup(var.containers[0], "working_directory", null)
  }
  dynamic "containers" {
    for_each = length(var.containers) > 1 ? slice(var.containers, 1, length(var.containers)) : []
    content {
    arguments             = lookup(containers.value, "arguments", null)
    command               = lookup(containers.value, "command", null)
    defined_tags          = lookup(containers.value, "defined_tags", local.default_tags)
    display_name          = lookup(containers.value, "display_name", null)
    environment_variables = lookup(containers.value, "environment_variables", null)
    dynamic "health_checks" {
      for_each = containers.value.health_checks != null ? containers.value.health_checks : []
      content {
        failure_action    = optional(health_checks.value.failure_action, null)
        failure_threshold = optional(health_checks.value.failure_threshold, null)
        dynamic "headers" {
          for_each = health_checks.value.headers != null ? [health_checks.value.headers] : []
          content {
            name  = headers.value.name
            value = headers.value.value
          }
        }
        health_check_type        = health_checks.value.health_check_type
        initial_delay_in_seconds = optional(health_checks.value.initial_delay_in_seconds, null)
        interval_in_seconds      = optional(health_checks.value.interval_in_seconds, null)
        name                     = optional(health_checks.value.name, null)
        path                     = optional(health_checks.value.path, null)
        port                     = health_checks.value.port
        success_threshold        = optional(health_checks.value.success_threshold, null)
        timeout_in_seconds       = optional(health_checks.value.timeout_in_seconds, null)
      }
    }
    image_url                      = containers.value.image_url
    is_resource_principal_disabled = lookup(containers.value, "is_resource_principal_disabled", null)
    dynamic "resource_config" {
      for_each = containers.value.resource_config != null ? [containers.value.resource_config] : []
      content {
        memory_limit_in_gbs = lookup(resource_config.value, "memory_limit_in_gbs", null)
        vcpus_limit         = lookup(resource_config.value, "vcpus_limit", null)
      }
    }
    dynamic "security_context" {
      for_each = containers.value.security_context != null ? [containers.value.security_context] : []
      content {
        dynamic "capabilities" {
          for_each = security_context.value.capabilities != null ? [security_context.value.capabilities] : []
          content {
            add_capabilities  = lookup(capabilities.value, "add_capabilities", null)
            drop_capabilities = lookup(capabilities.value, "drop_capabilities", null)
          }
        }
        is_non_root_user_check_enabled = lookup(security_context.value, "is_non_root_user_check_enabled", null)
        is_root_file_system_readonly   = lookup(security_context.value, "is_root_file_system_readonly", null)
        run_as_group                   = lookup(security_context.value, "run_as_group", null)
        run_as_user                    = lookup(security_context.value, "run_as_user", null)
        security_context_type          = lookup(security_context.value, "security_context_type", null)
      }
    }
    dynamic "volume_mounts" {
      for_each = containers.value.volume_mounts != null ? containers.value.volume_mounts : []
      content {
        is_read_only = lookup(volume_mounts.value, "is_read_only", null)
        mount_path   = volume_mounts.value.mount_path
        partition    = lookup(volume_mounts.value, "partition", null)
        sub_path     = lookup(volume_mounts.value, "sub_path", null)
        volume_name  = volume_mounts.value.volume_name
      }
    }
    working_directory = lookup(containers.value, "working_directory", null)
    }
  }
  defined_tags = local.defined_tags
  display_name = var.display_name
  dynamic "dns_config" {
    for_each = var.dns_config != null ? [var.dns_config] : []
    content {
      nameservers = lookup(dns_config.value, "nameservers", null)
      options     = lookup(dns_config.value, "options", null)
      searches    = lookup(dns_config.value, "searches", null)
    }
  }
  fault_domain                         = var.fault_domain
  graceful_shutdown_timeout_in_seconds = var.graceful_shutdown_timeout_in_seconds
  
  /*image_pull_secrets {
    registry_endpoint = var.image_pull_secrets.registry_endpoint
    secret_type       = var.image_pull_secrets.secret_type
    username          = lookup(var.image_pull_secrets, "username", null)
    password          = lookup(var.image_pull_secrets, "password", null)
    secret_id         = lookup(var.image_pull_secrets, "secret_id", null)
  }*/
  dynamic "image_pull_secrets" {
    for_each = var.image_pull_secrets != null ? [var.image_pull_secrets] : []
    content {
      registry_endpoint = image_pull_secrets.value.registry_endpoint
      secret_type       = image_pull_secrets.value.secret_type
      username          = lookup(image_pull_secrets.value, "username", null)
      password          = lookup(image_pull_secrets.value, "password", null)
      secret_id         = lookup(image_pull_secrets.value, "secret_id", null)
    }
  }
  shape = var.shape
  shape_config {
    memory_in_gbs = lookup(var.shape_config, "memory_in_gbs", null)
    ocpus         = var.shape_config.ocpus
  }
  vnics {
    defined_tags           = lookup(var.vnics, "defined_tags", null)
    display_name           = lookup(var.vnics, "display_name", null)
    hostname_label         = lookup(var.vnics, "hostname_label", null)
    is_public_ip_assigned  = lookup(var.vnics, "is_public_ip_assigned", null)
    nsg_ids                = lookup(var.vnics, "nsg_ids", null)
    private_ip             = lookup(var.vnics, "private_ip", null)
    skip_source_dest_check = lookup(var.vnics, "skip_source_dest_check", null)
    subnet_id              = var.vnics.subnet_id
  }
  dynamic "volumes" {
    for_each = var.volumes != null ? var.volumes : []
    content {
      backing_store = lookup(volumes.value, "backing_store", null)
      dynamic "configs" {
        for_each = volumes.value.configs != null ? [volumes.value.configs] : []
        content {
          data      = lookup(configs.value, "data", null)
          file_name = lookup(configs.value, "file_name", null)
          path      = lookup(configs.value, "path", null)
        }
      }
      name        = volumes.value.name
      volume_type = volumes.value.volume_type
    }
  }
  state = var.state
  lifecycle {
    ignore_changes = [
      defined_tags["IT.create_date"]
    ]
  }
}

resource "oci_identity_policy" "container_instance" {
  provider   = oci.home
  depends_on = [oci_container_instances_container_instance.instance]
  for_each = {
    for group in var.groups : group => group
    if var.groups != [] && var.compartment != null && var.policies == true
  }
  compartment_id = var.compartment_id
  name           = "policy_container_instances"
  description    = "allow one or more groups to use compute-container-family"
  statements = [
    "Allow group ${each.value} to use compute-container-family in compartment ${var.compartment}"
  ]  
}