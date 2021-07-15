# PostgreSQL Flexible Server is highly available
resource "azurerm_postgresql_flexible_server" "broker_database" {
  name                   = var.db_name
  resource_group_name    = azurerm_resource_group.res_group.name
  location               = azurerm_resource_group.res_group.location
  version                = "12"
  delegated_subnet_id    = azurerm_subnet.db_subnet.id
  administrator_login    = var.dbadmin_username
  administrator_password = var.dbadmin_password

  storage_mb = 32768

  sku_name = "GP_Standard_D4s_v3"
}

