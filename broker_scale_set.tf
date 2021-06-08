resource "azurerm_virtual_machine_scale_set" "broker_group" {
  name = "Broker_autoscale_group"
  location = var.region
  resource_group_name = azurerm_resource_group.res_group.name
  upgrade_policy_mode = "Manual"

  sku {
    name = "Standard_DS1_v2"
    tier = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_1"
    version   = "8.1.2020022700"
  }

  storage_profile_os_disk {
    name = "os_disk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun = 0
    caching = "ReadWrite"
    create_option = "Empty"
    disk_size_gb = 10
  }

  os_profile {
    computer_name_prefix = var.computer_name_prefix
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data = file(user_data.sh)
  }

  os_profile_linux_config {
    disable_password_authentication = true
  }

  network_profile {
    name = "scale_set_netprofile"
    primary = true
    
    ip_configuration {
        name = "scale_set_ip"
        subnet_id = azurerm_subnet.scale-set-subnet-private.id
        load_balancer_backend_address_pool_ids = azurerm_application_gateway.appgateway.backend_address_pool.id
        primary = true
    }
  }
  
  tags = {
      name = broker_scale_set
  }
}