output "config" {
  description = "contains service bus namespace configuration1"
  value       = azurerm_servicebus_namespace.ns
}

output "queues" {
  description = "contains service bus queues configuration"
  value       = azurerm_servicebus_queue.queue
}

output "queue_auth_rules" {
  description = "contains service bus queue authorization rules configuration"
  value       = azurerm_servicebus_queue_authorization_rule.queue_auth_rule
}

output "topics" {
  description = "contains service bus topics configuration"
  value       = azurerm_servicebus_topic.topic
}

output "topic_auth_rules" {
  description = "contains service bus topic authorization rules configuration"
  value       = azurerm_servicebus_topic_authorization_rule.topic_auth_rule
}

output "subscriptions" {
  description = "contains service bus topic subscriptions configuration"
  value       = azurerm_servicebus_subscription.subscription
}
