locals {
  project_name = var.project

  tags = merge(var.default_tags, {
    project = local.project_name
  })

  # Dodaj swoje adresy email do powiadomień budżetowych
  contact_emails = [
    "dawid.szymik@student.pk.edu.pl"
  ]

  # Konfiguracja principal_id dla SOPS
  principal_id = (
    var.sops_principal_object_id != ""
    ? var.sops_principal_object_id
    : data.azurerm_client_config.current.object_id
  )
}