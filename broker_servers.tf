# resource "tls_private_key" "ssh-key" {
#   algorithm = "RSA"
#   rsa_bits = 4096
# }

# output "tls_private_key" { value = "tls_private_key.ssh-key.private_key_pem" }


resource "azurerm_linux_virtual_machine" "broker" {
  count = 2
  name                  = "${var.instance_name}${count.index}"
  location              = var.region
  resource_group_name   = azurerm_resource_group.res_group.name
  size                = "Standard_F2"
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.broker_nic.id,
  ]
  disable_password_authentication = true

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
    Name = "${var.instance_name}${count.index}"
  }
}