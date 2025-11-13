# Storage Account dla zdalnego backendu
resource "azurerm_storage_account" "backend" {
  name                     = "azpkbcr2025g14k2148754"
  resource_group_name      = azurerm_resource_group.common["azpkbc-rg-basic-labs"].name
  location                 = azurerm_resource_group.common["azpkbc-rg-basic-labs"].location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Bezpieczeństwo
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"
  
  # Versioning dla historii state
  blob_properties {
    versioning_enabled = true
    
    # Soft delete jako backup
    delete_retention_policy {
      days = 30
    }
    
    container_delete_retention_policy {
      days = 30
    }
  }
  
  # Network restrictions (opcjonalnie)
  network_rules {
    default_action = "Allow" # Zmień na "Deny" dla większego bezpieczeństwa
    # ip_rules = ["YOUR_IP_ADDRESS"]
  }
  
  tags = merge(
    var.default_tags,
    { project = var.project },
    {
      Purpose   = "Terraform State Storage"
      ManagedBy = "OpenTofu"
    }
  )
}

# RBAC - uprawnienia do Storage Account dla remote backend
resource "azurerm_role_assignment" "storage_blob_data_contributor" {
  scope                = azurerm_storage_account.backend.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

# RBAC - uprawnienia dla Service Principal (jeśli używany)
resource "azurerm_role_assignment" "storage_blob_data_contributor_sp" {
  count                = var.sops_principal_object_id != "" ? 1 : 0
  scope                = azurerm_storage_account.backend.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.sops_principal_object_id
}

# Kontener dla state files
resource "azurerm_storage_container" "backend" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.backend.id
  container_access_type = "private"
}