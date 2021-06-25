output "resource_group" {
  value = azurerm_resource_group.res_group.id
}

output "application_gateway_frontend_ip" {
  value = azurerm_application_gateway.appgateway.frontend_ip_configuration
}

output broker {
  value       = azurerm_linux_virtual_machine.broker[*].private_ip_address
  description = "description"
}


# output "database_fqdn" {
#   value = azurerm_postgresql_flexible_server.broker_database.fqdn
# }

# output "db-subnet-address-prefix" {
#   value = azurerm_subnet.db-subnet-private
# }

