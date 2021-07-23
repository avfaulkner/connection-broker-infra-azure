locals {
  vars = {
    admin_password = "${var.admin_password}"
  }
}

resource "azurerm_linux_virtual_machine" "license" {
  name                = "license-${var.region}-${var.env}"
  location            = var.region
  resource_group_name = azurerm_resource_group.res_group.name
  size                = "Standard_F2s_v2"
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.license_nic.id,
  ]
  disable_password_authentication = true
  encryption_at_host_enabled = false

  custom_data = base64encode(templatefile("files/license_user_data.sh.tpl", local.vars))
  

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

  boot_diagnostics {}

  identity {
    type = "SystemAssigned"
  }


  tags = {
    Name = "license-server"
  }
}