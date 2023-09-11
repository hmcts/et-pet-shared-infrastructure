module "storage-account" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                      = var.env
  storage_account_name     = replace("${var.product}sa${var.env}", "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_kind             = var.sa_account_kind
  account_tier             = var.sa_account_tier
  account_replication_type = var.sa_account_replication_type
  containers = [
    {
      name        = "public"
      access_type = "private"
    },
    {
      name        = "private"
      access_type = "private"
    }
  ]
}