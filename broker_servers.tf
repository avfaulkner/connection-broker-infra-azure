# locals {
#   vars = {
#     db_admin = var.dbadmin_username,
#     db_endpoint = azurerm_postgresql_flexible_server.broker_database.fqdn,
#     db_name = azurerm_postgresql_flexible_server.broker_database.name
#   }
# }



resource "azurerm_linux_virtual_machine" "broker" {
  count = 2
  name                  = "${var.instance_name}${count.index}"
  location              = var.region
  resource_group_name   = azurerm_resource_group.res_group.name
  size                = "Standard_F2"
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.broker_nic[count.index].id,
  ]
  disable_password_authentication = true

  custom_data = filebase64("files/broker_user_data.sh")

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

  lifecycle {
    ignore_changes = [
      # We do not want VMs to get re-created when user data is changed
      custom_data,
    ]
  }


tags = {
    Name = "${var.instance_name}${count.index}"
  }
}