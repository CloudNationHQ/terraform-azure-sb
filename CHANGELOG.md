# Changelog

## [2.0.0](https://github.com/CloudNationHQ/terraform-azure-sb/compare/v1.3.0...v2.0.0) (2025-05-09)


### ⚠ BREAKING CHANGES

* The data structure changed, causing a recreate on existing resources.

### Features

* small refactor ([#23](https://github.com/CloudNationHQ/terraform-azure-sb/issues/23)) ([8a30da5](https://github.com/CloudNationHQ/terraform-azure-sb/commit/8a30da5a4b75441b0727f703ea2d0c6ef6bf2ba7))

### Upgrade from v1.3.0 to v2.0.0:

- Update module reference to: `version = "~> 2.0"`
- The property and variable resource_group is renamed to resource_group_name

## [1.3.0](https://github.com/CloudNationHQ/terraform-azure-sb/compare/v1.2.0...v1.3.0) (2025-04-15)


### Features

* add dynamic configuration for identity, customer managed key, and network rule set in service bus namespace ([#17](https://github.com/CloudNationHQ/terraform-azure-sb/issues/17)) ([946b190](https://github.com/CloudNationHQ/terraform-azure-sb/commit/946b1909598aa6f7bbd1f53b3e27e177088c3369))
* add type definitions ([#21](https://github.com/CloudNationHQ/terraform-azure-sb/issues/21)) ([0409456](https://github.com/CloudNationHQ/terraform-azure-sb/commit/0409456673e879ca1f6656fed1296fb38f71e060))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#16](https://github.com/CloudNationHQ/terraform-azure-sb/issues/16)) ([d0ee40b](https://github.com/CloudNationHQ/terraform-azure-sb/commit/d0ee40b48d85a68d8cbf4242465edd65f71a7631))
* **deps:** bump golang.org/x/net from 0.34.0 to 0.36.0 in /tests ([#19](https://github.com/CloudNationHQ/terraform-azure-sb/issues/19)) ([8e2b23d](https://github.com/CloudNationHQ/terraform-azure-sb/commit/8e2b23d937a923116de23ba53df449088613a0e2))

## [1.2.0](https://github.com/CloudNationHQ/terraform-azure-sb/compare/v1.1.0...v1.2.0) (2025-01-20)


### Features

* add client scoped subscription block and several missing properties in servicebus subscriptions, queues and rules ([#9](https://github.com/CloudNationHQ/terraform-azure-sb/issues/9)) ([418179f](https://github.com/CloudNationHQ/terraform-azure-sb/commit/418179fa81ed128ce33fc4e1c1349da10feb0dc4))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#8](https://github.com/CloudNationHQ/terraform-azure-sb/issues/8)) ([de3327f](https://github.com/CloudNationHQ/terraform-azure-sb/commit/de3327fad313af29b1be650153361b4a77c806ba))
* **deps:** bump golang.org/x/crypto from 0.29.0 to 0.31.0 in /tests ([#11](https://github.com/CloudNationHQ/terraform-azure-sb/issues/11)) ([c3ba87b](https://github.com/CloudNationHQ/terraform-azure-sb/commit/c3ba87b6943c70d1bf0f420f4033212e58a82ead))
* **deps:** bump golang.org/x/net from 0.31.0 to 0.33.0 in /tests ([#12](https://github.com/CloudNationHQ/terraform-azure-sb/issues/12)) ([9001ed8](https://github.com/CloudNationHQ/terraform-azure-sb/commit/9001ed8f97d65abe60ff6d2903a0b097dafe4952))
* remove temporary files when deployment tests fails ([#13](https://github.com/CloudNationHQ/terraform-azure-sb/issues/13)) ([8138aa7](https://github.com/CloudNationHQ/terraform-azure-sb/commit/8138aa7d0899458adfb2f19d7056248d89937ad7))

## [1.1.0](https://github.com/CloudNationHQ/terraform-azure-sb/compare/v1.0.0...v1.1.0) (2024-11-11)


### Features

* enhance testing with sequential, parallel modes and flags for exceptions and skip-destroy ([#6](https://github.com/CloudNationHQ/terraform-azure-sb/issues/6)) ([d5abb98](https://github.com/CloudNationHQ/terraform-azure-sb/commit/d5abb9867871bfa95e607c7e00a2f9f41695e195))


### Bug Fixes

* typo description input variable ([#4](https://github.com/CloudNationHQ/terraform-azure-sb/issues/4)) ([d47f1e3](https://github.com/CloudNationHQ/terraform-azure-sb/commit/d47f1e3a65a6a9bc9980686a4ad96546c4a63fd6))

## 1.0.0 (2024-10-18)


### Features

* add initial resources ([#2](https://github.com/CloudNationHQ/terraform-azure-sb/issues/2)) ([aac3a7c](https://github.com/CloudNationHQ/terraform-azure-sb/commit/aac3a7c1c40c7b8f2b2da9ed3419bf3e879c1724))
