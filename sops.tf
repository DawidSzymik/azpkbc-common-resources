# RBAC - przypisanie roli Key Vault Crypto User
resource "azurerm_role_assignment" "sops_crypto_user" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = local.principal_id
}

# Klucz szyfrujący dla SOPS (warunkowy - wyłączony na kontach edukacyjnych)
resource "azurerm_key_vault_key" "sops_encryption" {
  count = var.create_sops_key ? 1 : 0

  name         = "sops-encryption-key"
  key_vault_id = azurerm_key_vault.this.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt"]

  depends_on = [
    azurerm_role_assignment.sops_crypto_user
  ]

  lifecycle {
    prevent_destroy = true
  }
}