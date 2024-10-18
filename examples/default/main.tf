module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}


module "service_bus" {
  source  = "cloudnationhq/sb/azure"
  version = "~> 1.0"

  naming = local.naming

  config = {
    name           = module.naming.servicebus_namespace.name_unique
    resource_group = module.rg.groups.demo.name
    location       = module.rg.groups.demo.location
  }
}
