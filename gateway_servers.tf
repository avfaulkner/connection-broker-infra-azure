
resource "azurerm_linux_virtual_machine" "gateway" {
  name                  = "cmsg-gateway-${var.region}-${var.env}"
  location              = var.region
  resource_group_name   = azurerm_resource_group.res_group.name
  size                = "Standard_F2"
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.gateway_nic.id,
  ]
  disable_password_authentication = true

  custom_data = filebase64("files/cmsg_user_data.sh")

  admin_ssh_key {
    username       = var.admin_username
    public_key     = file("${var.ssh_pub_key_path}")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9"
    version   = "latest"
    # id = ""
  }

tags = {
    Name = "cmsg-gateway"
  }
}