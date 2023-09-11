locals {
  standard_subnets = [
    data.azurerm_subnet.jenkins_subnet.id,
    data.azurerm_subnet.jenkins_aks_00.id,
    data.azurerm_subnet.jenkins_aks_01.id,
    data.azurerm_subnet.cft_aks_00_subnet.id,
    data.azurerm_subnet.cft_aks_01_subnet.id
  ]

  preview_subnets   = var.env == "aat" ? [data.azurerm_subnet.preview_aks_00_subnet.id, data.azurerm_subnet.preview_aks_01_subnet.id] : []
  perftest_subnets  = var.env == "perftest" ? [data.azurerm_subnet.perftest_mgmt_subnet.id] : []
  all_valid_subnets = concat(local.standard_subnets, local.preview_subnets, local.perftest_subnets)
}

#data "azurerm_virtual_network" "mgmt_vnet" {
#  provider            = azurerm.mgmt
#  name                = "cft-ptl-vnet"
#  resource_group_name = "cft-ptl-network-rg"
#}
#
#data "azurerm_subnet" "jenkins_subnet" {
#  provider             = azurerm.mgmt
#  name                 = "iaas"
#  virtual_network_name = data.azurerm_virtual_network.mgmt_vnet.name
#  resource_group_name  = data.azurerm_virtual_network.mgmt_vnet.resource_group_name
#}

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

  sa_subnets = local.all_valid_subnets

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
