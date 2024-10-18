# Queues

This deploys service bus queues and authorization rules.

## Types

```hcl
config = object({
  name           = string
  resource_group = string
  location       = string
  queues = optional(map(object({
    max_size_in_megabytes                   = optional(number)
    default_message_ttl                     = optional(string)
    lock_duration                           = optional(string)
    max_delivery_count                      = optional(number)
    requires_session                        = optional(bool)
    dead_lettering_on_message_expiration    = optional(bool)
    requires_duplicate_detection            = optional(bool)
    duplicate_detection_history_time_window = optional(string)
    auto_delete_on_idle                     = optional(string)
    batched_operations_enabled              = optional(bool)
    partitioning_enabled                    = optional(bool)
    enable_batched_operations               = optional(bool)
    authorization_rules = optional(map(object({
      listen = optional(bool)
      send   = optional(bool)
      manage = optional(bool)
    })))
  })))
})
```
