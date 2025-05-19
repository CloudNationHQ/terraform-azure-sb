# Service Bus

This Terraform module streamlines the creation and management of azure service bus resources. It enables efficient messaging infrastructure for cloud native applications with minimal configuration.

## Features

Utilization of terratest for robust validation.

Supports creation of multiple service bus namespaces.

Enables multiple authorization rules per namespace.

Supports multiple queues with individual authorization rules.

Enables creation of multiple topics and subscriptions.

Allows multiple authorization rules per topic.

Supports multiple subscription rules per subscription.

Facilitates complex message filtering and routing configurations.

Offers three-tier naming hierarchy (explicit, convention-based, or key-based) for flexible resource management.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_servicebus_namespace.ns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace) (resource)
- [azurerm_servicebus_namespace_authorization_rule.auth_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace_authorization_rule) (resource)
- [azurerm_servicebus_queue.queue](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue) (resource)
- [azurerm_servicebus_queue_authorization_rule.queue_auth_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue_authorization_rule) (resource)
- [azurerm_servicebus_subscription.subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_subscription) (resource)
- [azurerm_servicebus_subscription_rule.rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_subscription_rule) (resource)
- [azurerm_servicebus_topic.topic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_topic) (resource)
- [azurerm_servicebus_topic_authorization_rule.topic_auth_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_topic_authorization_rule) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_config"></a> [config](#input\_config)

Description: Contains all service bus configuration

Type:

```hcl
object({
    name                          = string
    resource_group_name           = optional(string, null)
    location                      = optional(string, null)
    sku                           = optional(string, "Standard")
    capacity                      = optional(number, null)
    premium_messaging_partitions  = optional(number, null)
    public_network_access_enabled = optional(bool, true)
    minimum_tls_version           = optional(string, "1.2")
    local_auth_enabled            = optional(bool, true)
    tags                          = optional(map(string))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string), null)
    }), null)
    customer_managed_key = optional(object({
      key_vault_key_id                  = string
      identity_id                       = string
      infrastructure_encryption_enabled = optional(bool, false)
    }), null)
    network_rule_set = optional(object({
      default_action                = optional(string, "Allow")
      public_network_access_enabled = optional(bool, true)
      trusted_services_allowed      = optional(bool, false)
      ip_rules                      = optional(list(string), [])
      network_rules = optional(list(object({
        subnet_id                            = string
        ignore_missing_vnet_service_endpoint = optional(bool, false)
      })), [])
    }), null)
    authorization_rules = optional(map(object({
      name   = optional(string)
      listen = optional(bool, false)
      send   = optional(bool, false)
      manage = optional(bool, false)
    })), {})
    queues = optional(map(object({
      name                                    = optional(string)
      lock_duration                           = optional(string, "PT1M")
      max_size_in_megabytes                   = optional(number, null)
      max_delivery_count                      = optional(number, null)
      max_message_size_in_kilobytes           = optional(number, null)
      partitioning_enabled                    = optional(bool, false)
      express_enabled                         = optional(bool, false)
      requires_session                        = optional(bool, false)
      auto_delete_on_idle                     = optional(string, null)
      default_message_ttl                     = optional(string, null)
      batched_operations_enabled              = optional(bool, false)
      requires_duplicate_detection            = optional(bool, false)
      forward_dead_lettered_messages_to       = optional(string, null)
      dead_lettering_on_message_expiration    = optional(bool, false)
      duplicate_detection_history_time_window = optional(string, null)
      status                                  = optional(string, "Active")
      forward_to                              = optional(string, null)
      authorization_rules = optional(map(object({
        name   = optional(string)
        listen = optional(bool, false)
        send   = optional(bool, false)
        manage = optional(bool, false)
      })), {})
    })), {})
    topics = optional(map(object({
      name                                    = optional(string)
      duplicate_detection_history_time_window = optional(string, null)
      requires_duplicate_detection            = optional(bool, false)
      batched_operations_enabled              = optional(bool, false)
      default_message_ttl                     = optional(string, null)
      status                                  = optional(string, "Active")
      auto_delete_on_idle                     = optional(string, null)
      express_enabled                         = optional(bool, false)
      max_message_size_in_kilobytes           = optional(number, null)
      partitioning_enabled                    = optional(bool, false)
      max_size_in_megabytes                   = optional(number, null)
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
        default_message_ttl                       = optional(string, null)
        auto_delete_on_idle                       = optional(string, null)
        requires_session                          = optional(bool, false)
        dead_lettering_on_message_expiration      = optional(bool, false)
        dead_lettering_on_filter_evaluation_error = optional(bool, true)
        client_scoped_subscription_enabled        = optional(bool, false)
        forward_dead_lettered_messages_to         = optional(string, null)
        batched_operations_enabled                = optional(bool, false)
        status                                    = optional(string, "Active")
        forward_to                                = optional(string, null)
        client_scoped_subscription = optional(object({
          client_id                               = optional(string, null)
          is_client_scoped_subscription_shareable = optional(bool, false)
        }), null)
        rules = optional(map(object({
          name        = optional(string)
          filter_type = optional(string, "SqlFilter")
          sql_filter  = optional(string, null)
          correlation_filter = optional(object({
            content_type        = optional(string, null)
            correlation_id      = optional(string, null)
            label               = optional(string, null)
            message_id          = optional(string, null)
            reply_to            = optional(string, null)
            reply_to_session_id = optional(string, null)
            session_id          = optional(string, null)
            to                  = optional(string, null)
            properties          = optional(map(string), {})
          }), null)
          action = optional(string, null)
        })), {})
      })), {})
    })), {})
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

Default: `null`

### <a name="input_naming"></a> [naming](#input\_naming)

Description: contains naming convention

Type: `map(string)`

Default: `{}`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_config"></a> [config](#output\_config)

Description: contains service bus namespace configuration1

### <a name="output_queue_auth_rules"></a> [queue\_auth\_rules](#output\_queue\_auth\_rules)

Description: contains service bus queue authorization rules configuration

### <a name="output_queues"></a> [queues](#output\_queues)

Description: contains service bus queues configuration

### <a name="output_subscriptions"></a> [subscriptions](#output\_subscriptions)

Description: contains service bus topic subscriptions configuration

### <a name="output_topic_auth_rules"></a> [topic\_auth\_rules](#output\_topic\_auth\_rules)

Description: contains service bus topic authorization rules configuration

### <a name="output_topics"></a> [topics](#output\_topics)

Description: contains service bus topics configuration
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-sb/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-sb" />
</a>

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/service-bus-messaging/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/servicebus/)
- [Rest Api Specs](https://github.com/hashicorp/pandora/tree/main/api-definitions/resource-manager/ServiceBus)
