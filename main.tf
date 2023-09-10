resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location

  tags = var.common_tags
}

locals {
  tags = merge(
    var.common_tags,
    tomap({
      "Team Contact"        = var.team_contact
      "Destroy Me"          = var.destroy_me
      "application"         = "et-pet"
      "managedBy"           = "et-pet"
      "businessArea"        = "CFT"
      "contactSlackChannel" = var.team_contact
    })
  )
}

module "et-key-vault" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  product                 = var.product
  env                     = var.env
  tenant_id               = var.tenant_id
  object_id               = var.jenkins_AAD_objectId
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_name      = "dcd_group_pet_v2"
  common_tags             = var.common_tags
  create_managed_identity = true
}

resource "azurerm_key_vault_secret" "AZURE_APPINSIGHTS_KEY" {
  name         = "AppInsightsInstrumentationKey"
  value        = azurerm_application_insights.appinsights.instrumentation_key
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_application_insights" "appinsights" {
  name                = "${var.product}-appinsights-${var.env}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"

  tags = var.common_tags

  lifecycle {
    ignore_changes = [
      # Ignore changes to appinsights as otherwise upgrading to the Azure provider 2.x
      # destroys and re-creates this appinsights instance..
      application_type,
    ]
  }
}

resource "azurerm_key_vault_secret" "AZURE_APPINSIGHTS_KEY_PREVIEW" {
  name         = "AppInsightsInstrumentationKey-Preview"
  value        = azurerm_application_insights.appinsights_preview[0].instrumentation_key
  key_vault_id = module.et-key-vault.key_vault_id
  count        = var.env == "aat" ? 1 : 0
}

resource "azurerm_application_insights" "appinsights_preview" {
  name                = "${var.product}-appinsights-preview"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  count               = var.env == "aat" ? 1 : 0

  tags = var.common_tags

  lifecycle {
    ignore_changes = [
      # Ignore changes to appinsights as otherwise upgrading to the Azure provider 2.x
      # destroys and re-creates this appinsights instance..
      application_type,
    ]
  }
}
