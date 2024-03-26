module "et-database" {
  providers = {
    azurerm.postgres_network = azurerm.postgres_network
  }
  source = "git@github.com:hmcts/terraform-module-postgresql-flexible?ref=master"
  env    = var.env

  product       = var.product
  component     = "et"
  business_area = "cft"

  pgsql_databases = [
    {
      name : "et1"
    },
    {
      name : "et3"
    },
    {result = `az keyvault secret show --name et3-postgres-password --vault-name et-pet-aat`
puts result
      name : "etapi"
    }
  ]

  pgsql_version        = var.db_version
  admin_user_object_id = var.jenkins_AAD_objectId
  common_tags          = var.common_tags

  location         = var.location
  pgsql_storage_mb = var.db_storage_mb
}

resource "azurerm_key_vault_secret" "et1-postgres-user" {
  name         = "et1-postgres-user"
  value        = module.et-database.username
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et3-postgres-user" {
  name         = "et3-postgres-user"
  value        = module.et-database.username
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et-api-postgres-user" {
  name         = "et-api-postgres-user"
  value        = module.et-database.username
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et1-postgres-password" {
  name         = "et1-postgres-password"
  value        = module.et-database.password
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et3-postgres-password" {
  name         = "et3-postgres-password"
  value        = module.et-database.password
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et-api-postgres-password" {
  name         = "et-api-postgres-password"
  value        = module.et-database.password
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et1-postgres-host" {
  name         = "et1-postgres-host"
  value        = module.et-database.fqdn
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et3-postgres-host" {
  name         = "et3-postgres-host"
  value        = module.et-database.fqdn
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et-api-postgres-host" {
  name         = "et-api-postgres-host"
  value        = module.et-database.fqdn
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et1-postgres-port" {
  name         = "et1-postgres-port"
  value        = "5432"
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et3-postgres-port" {
  name         = "et3-postgres-port"
  value        = "5432"
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et-api-postgres-port" {
  name         = "et-api-postgres-port"
  value        = "5432"
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et1-postgres-database" {
  name         = "et1-postgres-database"
  value        = "et1"
  key_vault_id = module.et-key-vault.key_vault_id
}
resource "azurerm_key_vault_secret" "et3-postgres-database" {
  name         = "et3-postgres-database"
  value        = "et3"
  key_vault_id = module.et-key-vault.key_vault_id
}
resource "azurerm_key_vault_secret" "et-api-postgres-database" {
  name         = "et-api-postgres-database"
  value        = "etapi"
  key_vault_id = module.et-key-vault.key_vault_id
}
resource "azurerm_key_vault_secret" "et1-postgres-url" {
  name         = "et1-postgres-url"
  value        = "postgres://${module.et-database.username}:${module.et-database.password}@${module.et-database.fqdn}:5432/et1?POOL=15"
  key_vault_id = module.et-key-vault.key_vault_id
}
resource "azurerm_key_vault_secret" "et3-postgres-url" {
  name         = "et3-postgres-url"
  value        = "postgres://${module.et-database.username}:${module.et-database.password}@${module.et-database.fqdn}:5432/et3?POOL=15"
  key_vault_id = module.et-key-vault.key_vault_id
}
resource "azurerm_key_vault_secret" "et-api-postgres-url" {
  name         = "et-api-postgres-url"
  value        = "postgres://${module.et-database.username}:${module.et-database.password}@${module.et-database.fqdn}:5432/etapi?POOL=15"
  key_vault_id = module.et-key-vault.key_vault_id
}
