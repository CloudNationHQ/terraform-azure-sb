output "servicebus_namespace" {
  description = "contains service bus namespace configuration"
  value       = azurerm_servicebus_namespace.this
}

output "queues" {
  description = "contains service bus queues configuration"
  value       = azurerm_servicebus_queue.this
}

output "queue_auth_rules" {
  description = "contains service bus queue authorization rules configuration"
  value       = azurerm_servicebus_queue_authorization_rule.this
}

output "topics" {
  description = "contains service bus topics configuration"
  value       = azurerm_servicebus_topic.this
}

output "topic_auth_rules" {
  description = "contains service bus topic authorization rules configuration"
  value       = azurerm_servicebus_topic_authorization_rule.this
}

output "subscriptions" {
  description = "contains service bus topic subscriptions configuration"
  value       = azurerm_servicebus_subscription.this
}

output "namespace_auth_rules" {
  description = "contains service bus namespace authorization rules configuration"
  value       = azurerm_servicebus_namespace_authorization_rule.this
  sensitive   = true
}
