terraform {
  required_version = ">= 0.13"
  required_providers {
    azure = {
      source  = "hashicorp/azurerm"
      version = "2.63.0"
    }
    random = {
      source = "hashicorp/random"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
  backend "azurerm" { # Create remote backend to store terraform state file
    storage_account_name = "tfstate2026"
    container_name       = "tfstate" # The name of the blob container.
    key                  = "terraform.tfstate" #The name of the state store file to be created.
  }

}

provider "azurerm" {
  features {}
    # use_msi = true # managed_service_identity

}