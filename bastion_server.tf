# Linux Bastion
resource "azurerm_linux_virtual_machine" "bastion" {
  name                = "Bastion-${var.region}-${var.env}"
  location            = var.region
  resource_group_name = azurerm_resource_group.res_group.name
  size                = "Standard_F2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.bastion_nic.id,
  ]
  disable_password_authentication = false

  # custom_data = filebase64("files/bastion_user_data.sh")

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("${var.ssh_pub_key_path}")
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

  lifecycle {
    ignore_changes = [
      # We do not want VMs to get re-created when user data is changed
      custom_data,
    ]
  }


  tags = {
    Name = "Bastion"
  }
}
