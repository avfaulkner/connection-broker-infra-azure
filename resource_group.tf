# Create a resource group for all resources
resource "azurerm_resource_group" "res_group" {
  name     = "leostream-rg-${var.region}-${var.env}"
  location = var.region

  tags = {
    Name = "leostream-rg-dev"
  }
}