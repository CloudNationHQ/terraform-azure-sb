# namespace
resource "azurerm_servicebus_namespace" "ns" {
  name                          = var.config.name
  resource_group_name           = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  location                      = coalesce(lookup(var.config, "location", null), var.location)
  sku                           = try(var.config.sku, "Standard")
  capacity                      = try(var.config.capacity, null)
  premium_messaging_partitions  = try(var.config.premium_messaging_partitions, null)
  public_network_access_enabled = try(var.config.public_network_access_enabled, true)
  minimum_tls_version           = try(var.config.minimum_tls_version, "1.2")
  local_auth_enabled            = try(var.config.local_auth_enabled, true)

  tags = try(
    var.config.tags, var.tags, null
  )
}

# namespace authorization rules
resource "azurerm_servicebus_namespace_authorization_rule" "auth_rule" {
  for_each = lookup(
    var.config, "authorization_rules", {}
  )

  name = try(
    each.value.name, join("-", [var.naming.servicebus_namespace_authorization_rule, each.key])
  )

  namespace_id = azurerm_servicebus_namespace.ns.id
  listen       = try(each.value.listen, false)
  send         = try(each.value.send, false)
  manage       = try(each.value.manage, false)
}

# servicebus queues
resource "azurerm_servicebus_queue" "queue" {
  for_each = lookup(
    var.config, "queues", {}
  )

  name = try(
    each.value.name, join("-", [var.naming.servicebus_queue, each.key])
  )

  namespace_id                            = azurerm_servicebus_namespace.ns.id
  lock_duration                           = try(each.value.lock_duration, "PT1M")
  max_size_in_megabytes                   = try(each.value.max_size_in_megabytes, null)
  max_delivery_count                      = try(each.value.max_delivery_count, null)
  max_message_size_in_kilobytes           = try(each.value.max_message_size_in_kilobytes, null)
  partitioning_enabled                    = try(each.value.partitioning_enabled, false)
  express_enabled                         = try(each.value.express_enabled, false)
  requires_session                        = try(each.value.requires_session, false)
  auto_delete_on_idle                     = try(each.value.auto_delete_on_idle, null)
  default_message_ttl                     = try(each.value.default_message_ttl, null)
  batched_operations_enabled              = try(each.value.batched_operations_enabled, false)
  requires_duplicate_detection            = try(each.value.requires_duplicate_detection, false)
  forward_dead_lettered_messages_to       = try(each.value.forward_dead_lettered_messages_to, null)
  dead_lettering_on_message_expiration    = try(each.value.dead_lettering_on_message_expiration, false)
  duplicate_detection_history_time_window = try(each.value.duplicate_detection_history_time_window, null)
  status                                  = try(each.value.status, "Active")
  forward_to                              = try(each.value.forward_to, null)
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
  listen   = try(each.value.rule.listen, false)
  send     = try(each.value.rule.send, false)
  manage   = try(each.value.rule.manage, false)
}

# servicebus topics
resource "azurerm_servicebus_topic" "topic" {
  for_each = lookup(
    var.config, "topics", {}
  )

  name = try(
    each.value.name, join("-", [var.naming.servicebus_topic, each.key])
  )

  namespace_id                            = azurerm_servicebus_namespace.ns.id
  duplicate_detection_history_time_window = try(each.value.duplicate_detection_history_time_window, null)
  requires_duplicate_detection            = try(each.value.requires_duplicate_detection, false)
  batched_operations_enabled              = try(each.value.batched_operations_enabled, false)
  default_message_ttl                     = try(each.value.default_message_ttl, null)
  status                                  = try(each.value.status, "Active")
  auto_delete_on_idle                     = try(each.value.auto_delete_on_idle, null)
  express_enabled                         = try(each.value.express_enabled, false)
  max_message_size_in_kilobytes           = try(each.value.max_message_size_in_kilobytes, null)
  partitioning_enabled                    = try(each.value.partitioning_enabled, false)
  max_size_in_megabytes                   = try(each.value.max_size_in_megabytes, null)
  support_ordering                        = try(each.value.support_ordering, false)
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
  listen   = try(each.value.rule.listen, false)
  send     = try(each.value.rule.send, false)
  manage   = try(each.value.rule.manage, false)
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
  max_delivery_count                        = try(each.value.sub.max_delivery_count, 10)
  lock_duration                             = try(each.value.sub.lock_duration, "PT1M")
  default_message_ttl                       = try(each.value.sub.default_message_ttl, null)
  auto_delete_on_idle                       = try(each.value.sub.auto_delete_on_idle, null)
  requires_session                          = try(each.value.sub.requires_session, false)
  dead_lettering_on_message_expiration      = try(each.value.sub.dead_lettering_on_message_expiration, false)
  dead_lettering_on_filter_evaluation_error = try(each.value.sub.dead_lettering_on_filter_evaluation_error, true)
  client_scoped_subscription_enabled        = try(each.value.sub.client_scoped_subscription_enabled, false)
  forward_dead_lettered_messages_to         = try(each.value.sub.forward_dead_lettered_messages_to, null)
  batched_operations_enabled                = try(each.value.sub.batched_operations_enabled, false)
  status                                    = try(each.value.sub.status, "Active")
  forward_to                                = try(each.value.sub.forward_to, null)

  dynamic "client_scoped_subscription" {
    for_each = try(each.value.sub.client_scoped_subscription, null) != null ? [each.value.sub.client_scoped_subscription] : []

    content {
      client_id                               = try(client_scoped_subscription.value.client_id, null)
      is_client_scoped_subscription_shareable = try(client_scoped_subscription.value.is_client_scoped_subscription_shareable, false)
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
  filter_type     = try(each.value.rule.filter_type, "SqlFilter")

  sql_filter = each.value.rule.filter_type == "SqlFilter" ? each.value.rule.sql_filter : null

  dynamic "correlation_filter" {
    for_each = each.value.rule.filter_type == "CorrelationFilter" ? [each.value.rule.correlation_filter] : []

    content {
      content_type        = try(correlation_filter.value.content_type, null)
      correlation_id      = try(correlation_filter.value.correlation_id, null)
      label               = try(correlation_filter.value.label, null)
      message_id          = try(correlation_filter.value.message_id, null)
      reply_to            = try(correlation_filter.value.reply_to, null)
      reply_to_session_id = try(correlation_filter.value.reply_to_session_id, null)
      session_id          = try(correlation_filter.value.session_id, null)
      to                  = try(correlation_filter.value.to, null)
      properties          = try(correlation_filter.value.properties, {})
    }
  }

  action = try(each.value.rule.action, null)
}
