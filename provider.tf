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
}

# provider "azurerm" {
#   features {}
# }

