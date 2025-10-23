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