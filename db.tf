module "et1-database" {
  source             = "git@github.com:hmcts/cnp-module-postgres?ref=postgresql_tf"
  product            = var.product
  component          = "et1"
  location           = var.location
  env                = var.env
  postgresql_user    = var.db_postgresql_user
  database_name      = "et1"
  postgresql_version = "11"
  common_tags        = var.common_tags
  subscription       = var.subscription
  storage_mb         = var.db_storage_mb
}

module "et3-database" {
  source             = "git@github.com:hmcts/cnp-module-postgres?ref=postgresql_tf"
  product            = var.product
  component          = "et3"
  location           = var.location
  env                = var.env
  postgresql_user    = var.db_postgresql_user
  database_name      = "et3"
  postgresql_version = "11"
  common_tags        = var.common_tags
  subscription       = var.subscription
  storage_mb         = var.db_storage_mb
}

module "et-api-database" {
  source             = "git@github.com:hmcts/cnp-module-postgres?ref=postgresql_tf"
  product            = var.product
  component          = "api"
  location           = var.location
  env                = var.env
  postgresql_user    = var.db_postgresql_user
  database_name      = "api"
  postgresql_version = "11"
  common_tags        = var.common_tags
  subscription       = var.subscription
  storage_mb         = var.db_storage_mb
}

resource "azurerm_key_vault_secret" "et1-postgres-user" {
  name         = "et1-postgres-user"
  value        = module.et1-database.user_name
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et3-postgres-user" {
  name         = "et3-postgres-user"
  value        = module.et3-database.user_name
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et-api-postgres-user" {
  name         = "et-api-postgres-user"
  value        = module.et-api-database.user_name
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et1-postgres-password" {
  name         = "et1-postgres-password"
  value        = module.et1-database.postgresql_password
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et3-postgres-password" {
  name         = "et3-postgres-password"
  value        = module.et3-database.postgresql_password
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et-api-postgres-password" {
  name         = "et-api-postgres-password"
  value        = module.et-api-database.postgresql_password
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et1-postgres-host" {
  name         = "et1-postgres-host"
  value        = module.et1-database.host_name
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et3-postgres-host" {
  name         = "et3-postgres-host"
  value        = module.et3-database.host_name
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et-api-postgres-host" {
  name         = "et-api-postgres-host"
  value        = module.et-api-database.host_name
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et1-postgres-port" {
  name         = "et1-postgres-port"
  value        = module.et1-database.postgresql_listen_port
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et3-postgres-port" {
  name         = "et3-postgres-port"
  value        = module.et3-database.postgresql_listen_port
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et-api-postgres-port" {
  name         = "et-api-postgres-port"
  value        = module.et-api-database.postgresql_listen_port
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et1-postgres-database" {
  name         = "et1-postgres-database"
  value        = module.et1-database.postgresql_database
  key_vault_id = module.et-key-vault.key_vault_id
}
resource "azurerm_key_vault_secret" "et3-postgres-database" {
  name         = "et3-postgres-database"
  value        = module.et3-database.postgresql_database
  key_vault_id = module.et-key-vault.key_vault_id
}
resource "azurerm_key_vault_secret" "et-api-postgres-database" {
  name         = "et-api-postgres-database"
  value        = module.et-api-database.postgresql_database
  key_vault_id = module.et-key-vault.key_vault_id
}
