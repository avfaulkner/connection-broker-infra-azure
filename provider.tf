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
    # subscription_id      = "343d0214-92ab-4fd5-9cfd-55b9faba1e06"
    # tenant_id            = "715c7afb-027a-4b6e-9a60-dc385a62cf18"
    # access_key = "vPzdW71ACXJZYLZNRP4dsFtDTPxMAqfHGjbAOFm1FaDmLobNEckGHCN8xRaxfv0C3vY8mzvHzBDVM0x7UDhhLA=="
  }

}

provider "azurerm" {
  features {}
    # use_msi = true # managed_service_identity

}