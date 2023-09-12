locals {
  mgmt_network_name    = "cft-ptl-vnet"
  mgmt_network_rg_name = "cft-ptl-network-rg"

  aks_env = var.env == "sandbox" ? "sbox" : var.env

  aat_cft_vnet_name           = "cft-aat-vnet"
  aat_cft_vnet_resource_group = "cft-aat-network-rg"

  cft_aks_network_name    = "cft-${local.aks_env}-vnet"
  cft_aks_network_rg_name = "cft-${local.aks_env}-network-rg"

  preview_vnet_name           = "cft-preview-vnet"
  preview_vnet_resource_group = "cft-preview-network-rg"
  perftest_vnet_name           = "core-infra-vnet-perftest"
  perftest_subnet_name         = "core-infra-subnet-mgmtperftest"
  perftest_vnet_resource_group = "core-infra-perftest"
}

provider "azurerm" {
  alias           = "mgmt"
  subscription_id = var.mgmt_subscription_id
  features {}
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  alias                      = "aks"
  subscription_id            = var.aks_subscription_id
}

provider "azurerm" {
  features {}
  alias           = "aks_preview"
  subscription_id = "8b6ea922-0862-443e-af15-6056e1c9b9a4"
}

provider "azurerm" {
  features {}
  alias           = "aks_perftest_mgmt"
  subscription_id = "7a4e3bd5-ae3a-4d0c-b441-2188fee3ff1c"
}

data "azurerm_subnet" "perftest_mgmt_subnet" {
  provider             = azurerm.aks_perftest_mgmt
  name                 = local.perftest_subnet_name
  virtual_network_name = local.perftest_vnet_name
  resource_group_name  = local.perftest_vnet_resource_group
}

data "azurerm_subnet" "preview_aks_00_subnet" {
  provider             = azurerm.aks_preview
  name                 = "aks-00"
  virtual_network_name = local.preview_vnet_name
  resource_group_name  = local.preview_vnet_resource_group
}

data "azurerm_subnet" "preview_aks_01_subnet" {
  provider             = azurerm.aks_preview
  name                 = "aks-01"
  virtual_network_name = local.preview_vnet_name
  resource_group_name  = local.preview_vnet_resource_group
}

data "azurerm_subnet" "jenkins_subnet" {
  provider             = azurerm.mgmt
  name                 = "iaas"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

data "azurerm_subnet" "jenkins_aks_00" {
  provider             = azurerm.mgmt
  name                 = "aks-00"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

data "azurerm_subnet" "jenkins_aks_01" {
  provider             = azurerm.mgmt
  name                 = "aks-01"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

data "azurerm_subnet" "cft_aks_00_subnet" {
  provider             = azurerm.aks
  name                 = "aks-00"
  virtual_network_name = local.cft_aks_network_name
  resource_group_name  = local.cft_aks_network_rg_name
}

data "azurerm_subnet" "cft_aks_01_subnet" {
  provider             = azurerm.aks
  name                 = "aks-01"
  virtual_network_name = local.cft_aks_network_name
  resource_group_name  = local.cft_aks_network_rg_name
}