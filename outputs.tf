output "backend_config" {
  value = {
    resource_group_name  = azurerm_resource_group.common["azpkbc-rg-basic-labs"].name
    storage_account_name = azurerm_storage_account.backend.name
    container_name       = azurerm_storage_container.backend.name
  }
  description = "Backend configuration for OpenTofu"
}

output "access_keys" {
  value = var.enable_access_key ? {
    primary_access_key   = azurerm_storage_account.backend.primary_access_key
    secondary_access_key = azurerm_storage_account.backend.secondary_access_key
    connection_string    = azurerm_storage_account.backend.primary_connection_string
  } : null
  description = "Access keys dla backup/CI/CD (jeśli włączone)"
  sensitive   = true
}