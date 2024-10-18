# Subscription Rules

This deploys service bus topics with subscriptions, filtering and authorization rules.

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
    subscriptions = optional(map(object({
      max_delivery_count                   = optional(number)
      lock_duration                        = optional(string)
      auto_delete_on_idle                  = optional(string)
      requires_session                     = optional(bool)
      dead_lettering_on_message_expiration = optional(bool)
      rules = optional(map(object({
        filter_type = string
        sql_filter  = optional(string)
        correlation_filter = optional(object({
          label               = optional(string)
          content_type        = optional(string)
          correlation_id      = optional(string)
          message_id          = optional(string)
          reply_to            = optional(string)
          reply_to_session_id = optional(string)
          session_id          = optional(string)
          to                  = optional(string)
        }))
      })))
    })))
  })))
})
```
