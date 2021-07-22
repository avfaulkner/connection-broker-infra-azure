terraform {
  required_version = ">= 0.13"
  required_providers {
    azure = {
      source  = "hashicorp/azurerm"
      version = "2.65.0"
    }
    random = {
      source = "hashicorp/random"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
  backend "azurerm" { # Create remote backend to store terraform state file
    resource_group_name  = "tfstate"
    storage_account_name = ""
    container_name       = "tfstate"           # The name of the blob container.
    key                  = "terraform.tfstate" #The name of the state store file to be created.
    subscription_id      = ""
    tenant_id            = "" 
  }
}

provider "azurerm" {
  features {}
}
