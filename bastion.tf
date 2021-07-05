# Windows Bastion
resource "azurerm_windows_virtual_machine" "bastion" {
  name                = "bastion"
  resource_group_name = azurerm_resource_group.res_group.name
  location            = azurerm_resource_group.res_group.location
  size                = "Standard_B4ms"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.bastion_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # source_image_id = "" # ID of the image that this VM will be created from

  source_image_reference {
    publisher = "MicrosoftWindowsbastion"
    offer     = "Windows-10"
    sku       = "20h2-pro-g2"
    version   = "latest"
  }
}
