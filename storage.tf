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

data "azurerm_subnet" "private_endpoints" {
  provider             = azurerm.private_endpoints
  resource_group_name  = local.private_endpoint_rg_name
  virtual_network_name = local.private_endpoint_vnet_name
  name                 = "private-endpoints"
}