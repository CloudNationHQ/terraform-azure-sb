moved {
  from = azurerm_servicebus_namespace.ns
  to   = azurerm_servicebus_namespace.this
}

moved {
  from = azurerm_servicebus_namespace_authorization_rule.auth_rule
  to   = azurerm_servicebus_namespace_authorization_rule.this
}

moved {
  from = azurerm_servicebus_queue.queue
  to   = azurerm_servicebus_queue.this
}

moved {
  from = azurerm_servicebus_queue_authorization_rule.queue_auth_rule
  to   = azurerm_servicebus_queue_authorization_rule.this
}

moved {
  from = azurerm_servicebus_topic.topic
  to   = azurerm_servicebus_topic.this
}

moved {
  from = azurerm_servicebus_topic_authorization_rule.topic_auth_rule
  to   = azurerm_servicebus_topic_authorization_rule.this
}

moved {
  from = azurerm_servicebus_subscription.subscription
  to   = azurerm_servicebus_subscription.this
}

moved {
  from = azurerm_servicebus_subscription_rule.rule
  to   = azurerm_servicebus_subscription_rule.this
}
