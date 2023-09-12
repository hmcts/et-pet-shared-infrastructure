module "etapi-redis" {
  source                        = "git@github.com:hmcts/cnp-module-redis?ref=master"
  product                       = var.product
  name                          = "${var.product}-api-${var.env}"
  location                      = var.location
  env                           = var.env
  private_endpoint_enabled      = true
  redis_version                 = "6"
  business_area                 = "cft"
  public_network_access_enabled = false
  common_tags                   = var.common_tags
}

resource "azurerm_key_vault_secret" "redis6_access_key" {
  name         = "etapi-redis-access-key"
  value        = module.etapi-redis.access_key
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et-pet-api-redis-url" {
  name         = "et-pet-api-redis-url"
  value        = "rediss://:${urlencode(module.etapi-redis.access_key)}@${module.etapi-redis.host_name}:${module.etapi-redis.redis_port}"
  key_vault_id = module.et-key-vault.key_vault_id
}