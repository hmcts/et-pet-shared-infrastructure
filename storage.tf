locals {
  private_endpoint_rg_name   = "${var.business_area}-${var.env}-network-rg"
  private_endpoint_vnet_name = "${var.business_area}-${var.env}-vnet"
}

# CFT only
provider "azurerm" {
  alias           = "private_endpoints"
  subscription_id = var.aks_subscription_id
  features {}
  skip_provider_registration = true
}

provider "azurerm" {
  alias           = "mgmt"
  subscription_id = var.mgmt_subscription_id
  features {}
}

data "azurerm_subnet" "private_endpoints" {
  provider             = azurerm.private_endpoints
  resource_group_name  = local.private_endpoint_rg_name
  virtual_network_name = local.private_endpoint_vnet_name
  name                 = "private-endpoints"
}

data "azurerm_virtual_network" "mgmt_vnet" {
  provider            = azurerm.mgmt
  name                = "cft-ptl-vnet"
  resource_group_name = "cft-ptl-network-rg"
}

data "azurerm_subnet" "jenkins_subnet" {
  provider             = azurerm.mgmt
  name                 = "iaas"
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
  private_endpoint_subnet_id = data.azurerm_subnet.private_endpoints.id
  common_tags                = var.common_tags
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
