locals {
  topics = {
    events = {
      max_size_in_megabytes                   = 5120
      default_message_ttl                     = "P14D"
      requires_duplicate_detection            = true
      duplicate_detection_history_time_window = "PT30M"
      support_ordering                        = true
      authorization_rules = {
        publisher = {
          listen = false
          send   = true
          manage = false
        },
        subscriber = {
          listen = true
          send   = false
          manage = false
        },
        admin = {
          listen = true
          send   = true
          manage = true
        }
      }
    },
    notifications = {
      max_size_in_megabytes      = 1024
      default_message_ttl        = "P2D"
      batched_operations_enabled = true
      express_enabled            = true
      authorization_rules = {
        sender = {
          listen = false
          send   = true
          manage = false
        }
      }
    },
    logs = {
      max_size_in_megabytes = 5120
      auto_delete_on_idle   = "P7D"
      partitioning_enabled  = true
      status                = "Active"
    }
  }
}
