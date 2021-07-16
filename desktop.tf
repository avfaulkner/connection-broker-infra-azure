# #create windows desktop for demo purposes
# resource "azurerm_windows_virtual_machine" "desktop" {
#   name                = "desktop-${var.language}-${var.env}"
#   resource_group_name = azurerm_resource_group.res_group.name
#   location            = azurerm_resource_group.res_group.location
#   size                = "Standard_D2_v2"
#   admin_username      = var.admin_username
#   admin_password      = var.admin_password
#   network_interface_ids = [
#     azurerm_network_interface.desktop-nic.id,
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   # source_image_id = "" # ID of the image that this VM will be created from

#   source_image_reference {
#     publisher = "MicrosoftWindowsDesktop"
#     offer     = "Windows-10"
#     sku       = "120h1-pro"
#     version   = "2.7.41491.1010"
#   }
# }
