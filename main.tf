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
  value        = module.application_insights_main.instrumentation_key
  key_vault_id = module.et-key-vault.key_vault_id
}

module "application_insights_main" {
  source = "git@github.com:hmcts/terraform-module-application-insights?ref=main"

  env     = var.env
  product = var.product
  name    = "${var.product}-appinsights"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  common_tags         = var.common_tags
}

moved {
  from = azurerm_application_insights.appinsights
  to   = module.application_insights_main.azurerm_application_insights.this
}
resource "azurerm_key_vault_secret" "AZURE_APPINSIGHTS_KEY_PREVIEW" {
  name         = "AppInsightsInstrumentationKey-Preview"
  value        = module.application_insights_preview[0].instrumentation_key
  key_vault_id = module.et-key-vault.key_vault_id
  count        = var.env == "aat" ? 1 : 0
}

module "application_insights_preview" {
  count  = var.env == "aat" ? 1 : 0
  source = "git@github.com:hmcts/terraform-module-application-insights?ref=main"

  env      = "preview"
  product  = var.product
  location = var.location
  name     = "${var.product}-appinsights"

  resource_group_name = azurerm_resource_group.rg.name

  common_tags = var.common_tags
}

moved {
  from = azurerm_application_insights.appinsights_preview[0]
  to   = module.application_insights_preview[0].azurerm_application_insights.this
}
