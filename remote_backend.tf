# Resource Group for the Terraform State File
resource "azurerm_resource_group" "tfstate-rg" {
  name     = "tfstate"
  location = "eastus"
  lifecycle {
    prevent_destroy = true
  }  
  tags = {
    environment = var.env
  }
}

# Storage Account for the Terraform State File
resource "azurerm_storage_account" "tfstate-sta" {
  depends_on = [azurerm_resource_group.tfstate-rg]
 
  name = "tfstate6423"
  resource_group_name = azurerm_resource_group.tfstate-rg.name
  location = azurerm_resource_group.tfstate-rg.location
  account_kind = "StorageV2"
  account_tier = "Standard"
  access_tier = "Hot"
  account_replication_type = "LRS"
  enable_https_traffic_only = true
   
  lifecycle {
    prevent_destroy = true
  }  
  
  tags = {
    environment = var.env
  }
}
# Storage Container for the State File
resource "azurerm_storage_container" "tfstate-container" {
  depends_on = [azurerm_storage_account.tfstate-sta]
  
  name                 = "tfstate"
  storage_account_name = azurerm_storage_account.tfstate-sta.name

  lifecycle {
    prevent_destroy = true
  }
}
