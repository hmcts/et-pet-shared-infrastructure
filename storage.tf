provider "azurerm" {
  alias           = "mgmt"
  subscription_id = var.aks_subscription_id
  features {}
}

data "azurerm_virtual_network" "mgmt_vnet" {
  provider            = azurerm.mgmt
  name                = "cft-${var.env}-vnet"
  resource_group_name = "cft-${var.env}-network-rg"
}

data "azurerm_subnet" "aks00_subnet" {
  provider             = azurerm.mgmt
  name                 = "aks-00"
  virtual_network_name = data.azurerm_virtual_network.mgmt_vnet.name
  resource_group_name  = data.azurerm_virtual_network.mgmt_vnet.resource_group_name
}

data "azurerm_subnet" "aks01_subnet" {
  provider             = azurerm.mgmt
  name                 = "aks-01"
  virtual_network_name = data.azurerm_virtual_network.mgmt_vnet.name
  resource_group_name  = data.azurerm_virtual_network.mgmt_vnet.resource_group_name
}

module "storage-account" {
  source                     = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                        = var.env
  storage_account_name       = replace("${var.product}sa${var.env}", "-", "")
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = var.location
  account_kind               = var.sa_account_kind
  account_tier               = var.sa_account_tier
  account_replication_type   = var.sa_account_replication_type
  common_tags                = var.common_tags

  sa_subnets = [data.azurerm_subnet.aks00_subnet.id,data.azurerm_subnet.aks01_subnet.id]

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
