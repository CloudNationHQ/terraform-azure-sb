module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.32"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}


module "service_bus" {
  source  = "cloudnationhq/sb/azure"
  version = "~> 3.0"

  servicebus_namespace = {
    name                = module.naming.servicebus_namespace.name_unique
    resource_group_name = module.rg.groups.demo.name
    location            = module.rg.groups.demo.location

    authorization_rules = {
      reader = {
        listen = true
        send   = false
        manage = false
      },
      sender = {
        listen = false
        send   = true
        manage = false
      },
      manager = {
        listen = true
        send   = true
        manage = true
      },
      custom = {
        listen = true
        send   = true
        manage = false
      }
    }
  }
}
