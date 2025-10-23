locals {
  project_name = var.project

  tags = merge(var.default_tags, {
    project = local.project_name
  })

  contact_emails = [
    "dawid.szymik@student.pk.edu.pl"
  ]
}