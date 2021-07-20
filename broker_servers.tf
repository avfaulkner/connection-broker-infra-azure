resource "azurerm_availability_set" "avset" {
 name                         = "avset"
 location                     = azurerm_resource_group.res_group.location
 resource_group_name          = azurerm_resource_group.res_group.name
 platform_fault_domain_count  = 2
 platform_update_domain_count = 2
 managed                      = true
}

resource "azurerm_linux_virtual_machine" "broker0" {
  name                = "${var.instance_name}0-${var.region}-${var.env}"
  location            = var.region
  resource_group_name = azurerm_resource_group.res_group.name
  availability_set_id   = azurerm_availability_set.avset.id
  size                = "Standard_F2"
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.broker_nic0.id,
  ]
  disable_password_authentication = true

  custom_data = filebase64("files/broker_user_data.sh")

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

  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [var.identity_ids]
  }

  tags = {
    Name = "${var.instance_name}0"
  }
}

########################################

resource "azurerm_linux_virtual_machine" "broker1" {
  name                = "${var.instance_name}1-${var.region}-${var.env}"
  location            = var.region
  resource_group_name = azurerm_resource_group.res_group.name
  availability_set_id   = azurerm_availability_set.avset.id
  size                = "Standard_F2"
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.broker_nic1.id,
  ]
  disable_password_authentication = true

  custom_data = filebase64("files/broker_user_data.sh")

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

  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [var.identity_ids]
  }

  tags = {
    Name = "${var.instance_name}1"
  }
}