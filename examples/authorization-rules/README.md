# Authorization Rules

This deploys authorizations rules on a service bus namespace.

## Types

```hcl
config = object({
  name                = string
  resource_group      = string
  location            = string
  authorization_rules = optional(map(object({
    listen = optional(bool)
    send   = optional(bool)
    manage = optional(bool)
  })))
})
```
