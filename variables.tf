variable "config" {
  description = "Contains all service bus configuration"
  type = object({
    name                          = string
    resource_group_name           = optional(string)
    location                      = optional(string)
    sku                           = optional(string, "Standard")
    capacity                      = optional(number)
    premium_messaging_partitions  = optional(number)
    public_network_access_enabled = optional(bool, true)
    minimum_tls_version           = optional(string, "1.2")
    local_auth_enabled            = optional(bool, true)
    tags                          = optional(map(string))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    customer_managed_key = optional(object({
      key_vault_key_id                  = string
      identity_id                       = string
      infrastructure_encryption_enabled = optional(bool, false)
    }))
    network_rule_set = optional(object({
      default_action                = optional(string, "Allow")
      public_network_access_enabled = optional(bool, true)
      trusted_services_allowed      = optional(bool, false)
      ip_rules                      = optional(list(string), [])
      network_rules = optional(list(object({
        subnet_id                            = string
        ignore_missing_vnet_service_endpoint = optional(bool, false)
      })), [])
    }))
    authorization_rules = optional(map(object({
      name   = optional(string)
      listen = optional(bool, false)
      send   = optional(bool, false)
      manage = optional(bool, false)
    })), {})
    queues = optional(map(object({
      name                                    = optional(string)
      lock_duration                           = optional(string, "PT1M")
      max_size_in_megabytes                   = optional(number)
      max_delivery_count                      = optional(number)
      max_message_size_in_kilobytes           = optional(number)
      partitioning_enabled                    = optional(bool, false)
      express_enabled                         = optional(bool, false)
      requires_session                        = optional(bool, false)
      auto_delete_on_idle                     = optional(string)
      default_message_ttl                     = optional(string)
      batched_operations_enabled              = optional(bool, false)
      requires_duplicate_detection            = optional(bool, false)
      forward_dead_lettered_messages_to       = optional(string)
      dead_lettering_on_message_expiration    = optional(bool, false)
      duplicate_detection_history_time_window = optional(string)
      status                                  = optional(string, "Active")
      forward_to                              = optional(string)
      authorization_rules = optional(map(object({
        name   = optional(string)
        listen = optional(bool, false)
        send   = optional(bool, false)
        manage = optional(bool, false)
      })), {})
    })), {})
    topics = optional(map(object({
      name                                    = optional(string)
      duplicate_detection_history_time_window = optional(string)
      requires_duplicate_detection            = optional(bool, false)
      batched_operations_enabled              = optional(bool, false)
      default_message_ttl                     = optional(string)
      status                                  = optional(string, "Active")
      auto_delete_on_idle                     = optional(string)
      express_enabled                         = optional(bool, false)
      max_message_size_in_kilobytes           = optional(number)
      partitioning_enabled                    = optional(bool, false)
      max_size_in_megabytes                   = optional(number)
      support_ordering                        = optional(bool, false)
      authorization_rules = optional(map(object({
        name   = optional(string)
        listen = optional(bool, false)
        send   = optional(bool, false)
        manage = optional(bool, false)
      })), {})
      subscriptions = optional(map(object({
        name                                      = optional(string)
        max_delivery_count                        = optional(number, 10)
        lock_duration                             = optional(string, "PT1M")
        default_message_ttl                       = optional(string)
        auto_delete_on_idle                       = optional(string)
        requires_session                          = optional(bool, false)
        dead_lettering_on_message_expiration      = optional(bool, false)
        dead_lettering_on_filter_evaluation_error = optional(bool, true)
        client_scoped_subscription_enabled        = optional(bool, false)
        forward_dead_lettered_messages_to         = optional(string)
        batched_operations_enabled                = optional(bool, false)
        status                                    = optional(string, "Active")
        forward_to                                = optional(string)
        client_scoped_subscription = optional(object({
          client_id                               = optional(string)
          is_client_scoped_subscription_shareable = optional(bool, false)
        }))
        rules = optional(map(object({
          name        = optional(string)
          filter_type = optional(string, "SqlFilter")
          sql_filter  = optional(string)
          correlation_filter = optional(object({
            content_type        = optional(string)
            correlation_id      = optional(string)
            label               = optional(string)
            message_id          = optional(string)
            reply_to            = optional(string)
            reply_to_session_id = optional(string)
            session_id          = optional(string)
            to                  = optional(string)
            properties          = optional(map(string), {})
          }))
          action = optional(string)
        })), {})
      })), {})
    })), {})
  })
  validation {
    condition     = var.config.location != null || var.location != null
    error_message = "location must be provided either in the storage object or as a separate variable."
  }

  validation {
    condition     = var.config.resource_group_name != null || var.resource_group_name != null
    error_message = "resource group name must be provided either in the storage object or as a separate variable."
  }
}

variable "naming" {
  description = "contains naming convention"
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
