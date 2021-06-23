# Create a resource group for all resources
resource "azurerm_resource_group" "res_group" {
  name     = "leostream-resource-group"
  location = var.region

  tags = {
    Name = "leostream-resource-group"
  }
}