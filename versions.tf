terraform {
  required_version = "~> 1.10"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.40"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.0"
    }
  }
  
  # ZAKOMENTUJ lokalny backend:
  # backend "local" {
  #   path = "tfstate/terraform.tfstate"
  # }
  
  # DODAJ zdalny backend:
  backend "azurerm" {
    resource_group_name  = "azpkbc-rg-basic-labs"
    storage_account_name = "azpkbcr2025g14k2148754"
    container_name       = "tfstate"
    key                  = "azpkbc-common-resources/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "156f2dd5-7ab1-4226-8435-42430d34ee49"
}