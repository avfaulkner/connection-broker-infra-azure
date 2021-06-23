output "resource_group" {
  value = azurerm_resource_group.res_group.id
}

output "application_gateway" {
  value = azurerm_application_gateway.appgateway
}

output "database_fqdn" {
  value = azurerm_postgresql_flexible_server.broker_database.fqdn
}

output "db-subnet-address-prefix" {
  value = azurerm_subnet.db-subnet-private
}

