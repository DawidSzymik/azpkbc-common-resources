data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                        = "azpkbc-vault-ds"
  location                    = azurerm_resource_group.common["azpkbc-rg-basic-labs"].location
  resource_group_name         = azurerm_resource_group.common["azpkbc-rg-basic-labs"].name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  sku_name                    = "standard"
  rbac_authorization_enabled  = true

  tags = local.tags

  lifecycle {
    prevent_destroy = true
  }
}