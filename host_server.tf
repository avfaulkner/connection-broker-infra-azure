resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

output "tls_private_key" { value = "tls_private_key.ssh-key.private_key_pem" }

resource "azurerm_linux_virtual_machine" "remote-host" {
  name                  = var.instance_name
  location              = var.region
  resource_group_name   = azurerm_resource_group.res_group.name
  network_interface_ids = [azurerm_network_interface.remote-host-nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name              = "server-disk"
    caching           = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_1"
    version   = "8.1.2020022700"
  }

  computer_name  = var.instance_name
  admin_username = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username       = var.admin_username
    public_key     = tls_private_key.ssh-key.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  tags = {
    Name = "${var.owner}-${var.instance_name}"
  }
}