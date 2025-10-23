variable "project" {
  description = "Project name"
  type        = string
  nullable    = false
  default     = "azpkbc-common-resources"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  nullable    = false
  default     = "grupa1"
}

variable "location" {
  description = "Azure region"
  nullable    = false
  type        = string
  default     = "sweden central"
}

variable "default_tags" {
  description = "Typowe tagi dla zasobów."
  nullable    = false
  type = object({
    environment = string
    project     = string
    lab         = string
    group       = string
    owner       = string
  })
  default = {
    environment = "dev"
    project     = "prc-lab"
    lab         = "0"
    group       = "14Kx"
    owner       = "Jan Kowalski"
  }
}
variable "common_resource_groups" {
  description = "Resource group name"
  type = map(object({
    enabled = bool
    tags = object({
      lab = string
    })
  }))
  nullable = false
  default = {
    "azpkbc-rg-basic-labs" = {
      enabled = true
      tags = {
        lab = "1-4"
      }
    }
    "azpkbc-rg-function-labs" = {
      enabled = true
      tags = {
        lab = "5-7"
      }
    }
    "azpkbc-rg-vm-labs" = {
      enabled = false
      tags = {
        lab = "6-7"
      }
    }
    "azpkbc-rg-advanced-labs" = {
      enabled = false
      tags = {
        lab = "8-10"
      }
    }
  }
}