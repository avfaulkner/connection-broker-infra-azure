# The shared image gallery will store golden images for the desktops
resource "azurerm_shared_image_gallery" "golden-images" {
  name                = "golden_images"
  resource_group_name = azurerm_resource_group.res_group.name
  location            = azurerm_resource_group.res_group.location
  description         = "Shared images and things."

  tags = {
    Name = "golden-images"
  }
}

