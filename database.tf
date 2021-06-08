resource "azurerm_postgresql_server" "postgres-server" {
  name                = "postgresql-server-1"
  location            = azurerm_resource_group.res_group.location
  resource_group_name = azurerm_resource_group.res_group.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  administrator_login          = var.dbadmin_username
  administrator_login_password = var.dbadmin_password
  version                      = "9.5"
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "example" {
  name                = "broker_database"
  resource_group_name = azurerm_resource_group.res_group.name
  server_name         = azurerm_postgresql_server.postgres-server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}
