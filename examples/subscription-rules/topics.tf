locals {
  topics = {
    events = {
      max_size_in_megabytes                   = 5120
      default_message_ttl                     = "P14D"
      requires_duplicate_detection            = true
      duplicate_detection_history_time_window = "PT30M"
      support_ordering                        = true
      subscriptions = {
        all-events = {
          max_delivery_count = 10
          lock_duration      = "PT5M"
          rules = {
            all_messages = {
              filter_type = "SqlFilter"
              sql_filter  = "1=1"
            }
          }
        },
        high-priority = {
          max_delivery_count = 5
          lock_duration      = "PT2M"
          requires_session   = true
          rules = {
            urgent = {
              filter_type = "CorrelationFilter"
              correlation_filter = {
                label = "urgent"
              }
            },
            important = {
              filter_type = "SqlFilter"
              sql_filter  = "Priority > 100"
            }
          }
        }
      }
    },
    notifications = {
      max_size_in_megabytes      = 1024
      default_message_ttl        = "P2D"
      batched_operations_enabled = true
      express_enabled            = true
      subscriptions = {
        email = {
          max_delivery_count  = 3
          auto_delete_on_idle = "P7D"
          rules = {
            email = {
              filter_type = "SqlFilter"
              sql_filter  = "type = 'email'"
            }
          }
        },
        sms = {
          max_delivery_count                   = 3
          dead_lettering_on_message_expiration = true
          rules = {
            sms = {
              filter_type = "SqlFilter"
              sql_filter  = "type = 'sms'"
            }
          }
        }
      }
    }
  }
}
