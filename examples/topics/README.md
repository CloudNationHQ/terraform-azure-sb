# Topics

This deploys servicebus topics and authorization rules.

## Types

```hcl
config = object({
  name           = string
  resource_group = string
  location       = string
  topics = optional(map(object({
    max_size_in_megabytes                   = optional(number)
    default_message_ttl                     = optional(string)
    requires_duplicate_detection            = optional(bool)
    duplicate_detection_history_time_window = optional(string)
    support_ordering                        = optional(bool)
    batched_operations_enabled              = optional(bool)
    express_enabled                         = optional(bool)
    auto_delete_on_idle                     = optional(string)
    partitioning_enabled                    = optional(bool)
    status                                  = optional(string)
    authorization_rules = optional(map(object({
      listen = bool
      send   = bool
      manage = bool
    })))
  })))
})
```
