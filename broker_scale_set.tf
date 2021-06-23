resource "azurerm_virtual_machine_scale_set" "broker_group" {
  name                = "broker_autoscale_group"
  location            = var.region
  resource_group_name = azurerm_resource_group.res_group.name
  upgrade_policy_mode = "Manual"

  sku {
    name     = "Standard_DS1_v2"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9"
    version   = "latest"
    # id = ""
  }

  storage_profile_os_disk {
    # name          = "os_disk"
    caching       = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = var.computer_name_prefix
    admin_username       = var.admin_username
    admin_password       = var.admin_password
    custom_data          = file("files/user_data.sh")
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = file("${var.ssh_pub_key_path}")
    }
  }

  network_profile {
    name    = "scale_set_netprofile"
    primary = true

    ip_configuration {
      name                                         = "scale_set_ip"
      subnet_id                                    = azurerm_subnet.scale-set-subnet-backend.id
      application_gateway_backend_address_pool_ids = [azurerm_application_gateway.appgateway.backend_address_pool[0].id]
      primary                                      = true
    }
  }

  tags = {
    name = "broker_scale_set"
  }
}