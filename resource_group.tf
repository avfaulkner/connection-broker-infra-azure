# Create a resource group for all resources
resource "azurerm_resource_group" "res_group" {
  name     = "af-certiport-rg"
  location = var.region

  tags = {
    Name = "resource-group"
  }
}