output "resource_group" {
  value = azurerm_resource_group.res_group.id
}

output "gateway_frontend_ip" {
  value = azurerm_public_ip.lb_ip.ip_address
}

output "broker_frontend_ip" {
  value = azurerm_public_ip.lb_broker_ip.ip_address
}

output "broker_frontend_fqdn" {
  value = azurerm_public_ip.lb_broker_ip.fqdn
}

output "database_fqdn" {
  value = azurerm_postgresql_flexible_server.broker_database.fqdn
}

output "bastion_public_ip" {
  value = azurerm_public_ip.bastion_pub_ip.ip_address
}

output "leostream_broker0" {
  value = azurerm_public_ip.broker_pub_ip0.ip_address
}

# output "leostream_broker1" {
#   value = azurerm_public_ip.broker_pub_ip1.ip_address
# }

output "license_server_ip" {
  value = azurerm_network_interface.license_nic.private_ip_address
}

output "terraform_state_resource_group_name" {
  value = azurerm_resource_group.tfstate-rg.name
}

output "terraform_state_storage_account" {
  value = azurerm_storage_account.tfstate-sta.name
}

output "terraform_state_storage_container" {
  value = azurerm_storage_container.tfstate-container.name
}
