resource "azurerm_resource_group" "common" {
  for_each = { for k, v in var.common_resource_groups : k => v if v.enabled }

  name     = each.key
  location = var.location
  tags = merge(
    { name = each.key },
    merge(local.tags, each.value.tags)
  )

  lifecycle {
    prevent_destroy = true
  }
}

data "azurerm_subscription" "current" {
}

resource "azurerm_consumption_budget_subscription" "this" {
  name            = "Budget-for-10-usd-subscription-cunsumption"
  subscription_id = data.azurerm_subscription.current.id

  amount     = 10 # EUR
  time_grain = "Monthly"

  time_period {
    start_date = "2025-10-01T00:00:00Z"
    end_date   = "2026-10-01T00:00:00Z"
  }

  notification {
    enabled        = true
    threshold      = 80.0 # %
    operator       = "EqualTo"
    contact_emails = local.contact_emails
  }

  notification {
    enabled        = true
    threshold      = 90.0 # %
    operator       = "EqualTo"
    contact_emails = local.contact_emails
  }

  notification {
    enabled        = true
    threshold      = 100.0
    operator       = "GreaterThan"
    threshold_type = "Forecasted"
    contact_emails = local.contact_emails
  }

  lifecycle {
    prevent_destroy = true
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                        = "azpkbc-vault-ds"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.common["azpkbc-rg-basic-labs"].name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions         = ["Backup", "Create", "Delete", "Get", "List", "Recover", "Purge", "Restore"]
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Set"]
    storage_permissions     = ["Get", "List"]
    certificate_permissions = ["Get", "List"]
  }

  tags = local.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_key_vault_secret" "sp_secrets" {
  for_each = toset(["devops-sp-username", "devops-sp-password"])

  name         = each.key
  value        = "put-secret-here"
  key_vault_id = azurerm_key_vault.this.id

  tags = local.tags

  lifecycle {
    prevent_destroy = true
  }
}