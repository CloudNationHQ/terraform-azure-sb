# namespace
resource "azurerm_servicebus_namespace" "ns" {
  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group", null
    ), var.resource_group
  )

  location = coalesce(
    lookup(var.config, "location", null
    ), var.location
  )

  name                          = var.config.name
  sku                           = var.config.sku
  capacity                      = var.config.capacity
  premium_messaging_partitions  = var.config.premium_messaging_partitions
  public_network_access_enabled = var.config.public_network_access_enabled
  minimum_tls_version           = var.config.minimum_tls_version
  local_auth_enabled            = var.config.local_auth_enabled

  dynamic "identity" {
    for_each = try(var.config.identity, null) != null ? [var.config.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "customer_managed_key" {
    for_each = try(var.config.customer_managed_key, null) != null ? [var.config.customer_managed_key] : []

    content {
      key_vault_key_id                  = customer_managed_key.value.key_vault_key_id
      identity_id                       = customer_managed_key.value.identity_id
      infrastructure_encryption_enabled = customer_managed_key.value.infrastructure_encryption_enabled
    }
  }

  dynamic "network_rule_set" {
    for_each = try(var.config.network_rule_set, null) != null ? [var.config.network_rule_set] : []

    content {
      default_action                = network_rule_set.value.default_action
      public_network_access_enabled = network_rule_set.value.public_network_access_enabled
      trusted_services_allowed      = network_rule_set.value.trusted_services_allowed
      ip_rules                      = network_rule_set.value.ip_rules

      dynamic "network_rules" {
        for_each = try(network_rule_set.value.network_rules, [])

        content {
          subnet_id                            = network_rule.value.subnet_id
          ignore_missing_vnet_service_endpoint = network_rule.value.ignore_missing_vnet_service_endpoint
        }
      }
    }
  }

  tags = try(
    var.config.tags, var.tags, null
  )
}

# namespace authorization rules
resource "azurerm_servicebus_namespace_authorization_rule" "auth_rule" {
  for_each = lookup(
    var.config, "authorization_rules", {}
  )

  name = coalesce(
    each.value.name, join("-", [var.naming.servicebus_namespace_authorization_rule, each.key])
  )

  namespace_id = azurerm_servicebus_namespace.ns.id
  listen       = each.value.listen
  send         = each.value.send
  manage       = each.value.manage
}

# servicebus queues
resource "azurerm_servicebus_queue" "queue" {
  for_each = lookup(
    var.config, "queues", {}
  )

  name = coalesce(
    each.value.name, join("-", [var.naming.servicebus_queue, each.key])
  )

  namespace_id                            = azurerm_servicebus_namespace.ns.id
  lock_duration                           = each.value.lock_duration
  max_size_in_megabytes                   = each.value.max_size_in_megabytes
  max_delivery_count                      = each.value.max_delivery_count
  max_message_size_in_kilobytes           = each.value.max_message_size_in_kilobytes
  partitioning_enabled                    = each.value.partitioning_enabled
  express_enabled                         = each.value.express_enabled
  requires_session                        = each.value.requires_session
  auto_delete_on_idle                     = each.value.auto_delete_on_idle
  default_message_ttl                     = each.value.default_message_ttl
  batched_operations_enabled              = each.value.batched_operations_enabled
  requires_duplicate_detection            = each.value.requires_duplicate_detection
  forward_dead_lettered_messages_to       = each.value.forward_dead_lettered_messages_to
  dead_lettering_on_message_expiration    = each.value.dead_lettering_on_message_expiration
  duplicate_detection_history_time_window = each.value.duplicate_detection_history_time_window
  status                                  = each.value.status
  forward_to                              = each.value.forward_to
}

# servicebus queue authorization rules
resource "azurerm_servicebus_queue_authorization_rule" "queue_auth_rule" {
  for_each = {
    for rule in flatten([
      for queue_key, queue in lookup(var.config, "queues", {}) : [
        for rule_key, rule in lookup(queue, "authorization_rules", {}) : {
          queue_key = queue_key
          rule_key  = rule_key
          rule      = rule
          rule_name = lookup(rule, "name", null) != null ? rule.name : join("-", [var.naming.servicebus_queue_authorization_rule, rule_key])
        }
      ]
    ]) : "${rule.queue_key}_${rule.rule_key}" => rule
  }

  name     = each.value.rule_name
  queue_id = azurerm_servicebus_queue.queue[each.value.queue_key].id
  listen   = each.value.rule.listen
  send     = each.value.rule.send
  manage   = each.value.rule.manage
}

# servicebus topics
resource "azurerm_servicebus_topic" "topic" {
  for_each = lookup(
    var.config, "topics", {}
  )

  name = coalesce(
    each.value.name, join("-", [var.naming.servicebus_topic, each.key])
  )

  namespace_id                            = azurerm_servicebus_namespace.ns.id
  duplicate_detection_history_time_window = each.value.duplicate_detection_history_time_window
  requires_duplicate_detection            = each.value.requires_duplicate_detection
  batched_operations_enabled              = each.value.batched_operations_enabled
  default_message_ttl                     = each.value.default_message_ttl
  status                                  = each.value.status
  auto_delete_on_idle                     = each.value.auto_delete_on_idle
  express_enabled                         = each.value.express_enabled
  max_message_size_in_kilobytes           = each.value.max_message_size_in_kilobytes
  partitioning_enabled                    = each.value.partitioning_enabled
  max_size_in_megabytes                   = each.value.max_size_in_megabytes
  support_ordering                        = each.value.support_ordering
}

# servicebus topic authorization rules
resource "azurerm_servicebus_topic_authorization_rule" "topic_auth_rule" {
  for_each = {
    for rule in flatten([
      for topic_key, topic in lookup(var.config, "topics", {}) : [
        for rule_key, rule in lookup(topic, "authorization_rules", {}) : {
          topic_key = topic_key
          rule_key  = rule_key
          rule      = rule
          rule_name = lookup(rule, "name", null) != null ? rule.name : join("-", [var.naming.servicebus_topic_authorization_rule, rule_key])
        }
      ]
    ]) : "${rule.topic_key}_${rule.rule_key}" => rule
  }

  name     = each.value.rule_name
  topic_id = azurerm_servicebus_topic.topic[each.value.topic_key].id
  listen   = each.value.rule.listen
  send     = each.value.rule.send
  manage   = each.value.rule.manage
}

# service bus topic subscriptions
resource "azurerm_servicebus_subscription" "subscription" {
  for_each = {
    for sub in flatten([
      for topic_key, topic in lookup(var.config, "topics", {}) : [
        for sub_key, sub in lookup(topic, "subscriptions", {}) : {
          topic_key = topic_key
          sub_key   = sub_key
          sub       = sub
          sub_name  = lookup(sub, "name", null) != null ? sub.name : join("-", [var.naming.servicebus_subscription, sub_key])
        }
      ]
    ]) : "${sub.topic_key}_${sub.sub_key}" => sub
  }

  name                                      = each.value.sub_name
  topic_id                                  = azurerm_servicebus_topic.topic[each.value.topic_key].id
  max_delivery_count                        = each.value.sub.max_delivery_count
  lock_duration                             = each.value.sub.lock_duration
  default_message_ttl                       = each.value.sub.default_message_ttl
  auto_delete_on_idle                       = each.value.sub.auto_delete_on_idle
  requires_session                          = each.value.sub.requires_session
  dead_lettering_on_message_expiration      = each.value.sub.dead_lettering_on_message_expiration
  dead_lettering_on_filter_evaluation_error = each.value.sub.dead_lettering_on_filter_evaluation_error
  client_scoped_subscription_enabled        = each.value.sub.client_scoped_subscription_enabled
  forward_dead_lettered_messages_to         = each.value.sub.forward_dead_lettered_messages_to
  batched_operations_enabled                = each.value.sub.batched_operations_enabled
  status                                    = each.value.sub.status
  forward_to                                = each.value.sub.forward_to

  dynamic "client_scoped_subscription" {
    for_each = try(each.value.sub.client_scoped_subscription, null) != null ? [each.value.sub.client_scoped_subscription] : []

    content {
      client_id                               = client_scoped_subscription.value.client_id
      is_client_scoped_subscription_shareable = client_scoped_subscription.value.is_client_scoped_subscription_shareable
    }
  }
}

# service bus subscription rules
resource "azurerm_servicebus_subscription_rule" "rule" {
  for_each = {
    for rule in flatten([
      for topic_key, topic in lookup(var.config, "topics", {}) :
      [for sub_key, sub in lookup(topic, "subscriptions", {}) :
        [for rule_key, rule in lookup(sub, "rules", {}) : {
          topic_key = topic_key
          sub_key   = sub_key
          rule_key  = rule_key
          rule      = rule
          rule_name = lookup(rule, "name", null) != null ? rule.name : join("-", [var.naming.servicebus_subscription_rule, rule_key])
        }]
      ]
    ]) : "${rule.topic_key}_${rule.sub_key}_${rule.rule_key}" => rule
  }

  name            = each.value.rule_name
  subscription_id = azurerm_servicebus_subscription.subscription["${each.value.topic_key}_${each.value.sub_key}"].id
  filter_type     = each.value.rule.filter_type

  sql_filter = each.value.rule.filter_type == "SqlFilter" ? each.value.rule.sql_filter : null

  dynamic "correlation_filter" {
    for_each = each.value.rule.filter_type == "CorrelationFilter" ? [each.value.rule.correlation_filter] : []

    content {
      content_type        = correlation_filter.value.content_type
      correlation_id      = correlation_filter.value.correlation_id
      label               = correlation_filter.value.label
      message_id          = correlation_filter.value.message_id
      reply_to            = correlation_filter.value.reply_to
      reply_to_session_id = correlation_filter.value.reply_to_session_id
      session_id          = correlation_filter.value.session_id
      to                  = correlation_filter.value.to
      properties          = correlation_filter.value.properties
    }
  }

  action = each.value.rule.action
}
