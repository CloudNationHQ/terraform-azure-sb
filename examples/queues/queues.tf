locals {
  queues = {
    orders = {
      max_size_in_megabytes = 5120
      default_message_ttl   = "P14D"
      lock_duration         = "PT5M"
      max_delivery_count    = 10
      requires_session      = true
      authorization_rules = {
        reader = {
          listen = true
          send   = false
          manage = false
        },
        writer = {
          listen = false
          send   = true
          manage = false
        },
        manager = {
          listen = true
          send   = true
          manage = true
        }
      }
    },
    notifications = {
      max_size_in_megabytes                   = 1024
      max_delivery_count                      = 3
      dead_lettering_on_message_expiration    = true
      requires_duplicate_detection            = true
      duplicate_detection_history_time_window = "PT10M"
      authorization_rules = {
        sender = {
          listen = false
          send   = true
          manage = false
        }
      }
    },
    logging = {
      max_size_in_megabytes      = 5120
      max_delivery_count         = 1
      auto_delete_on_idle        = "P7D"
      batched_operations_enabled = true
    },
    high_throughput = {
      max_size_in_megabytes     = 5120
      partitioning_enabled      = true
      enable_batched_operations = true
    }
  }
}
