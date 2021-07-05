
# Create a virtual network within the resource group
resource "azurerm_virtual_network" "virt-network" {
  name                = "virtual-network"
  resource_group_name = azurerm_resource_group.res_group.name
  location            = azurerm_resource_group.res_group.location
  address_space       = var.virtual_network
}

############################################################
# App Gateway 
resource "azurerm_subnet" "gateway-subnet-frontend" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.res_group.name
  virtual_network_name = azurerm_virtual_network.virt-network.name
  address_prefixes     = [var.gateway-subnet-frontend]
}

############################################################
# Brokers
resource "azurerm_subnet" "broker_subnet" {
  name                 = "broker_subnet"
  resource_group_name  = azurerm_resource_group.res_group.name
  virtual_network_name = azurerm_virtual_network.virt-network.name
  address_prefixes     = [var.broker_subnet]
}

resource "azurerm_network_interface" "broker_nic" {
  count = 2
  name                = "broker-nic${count.index}"
  location            = azurerm_resource_group.res_group.location
  resource_group_name = azurerm_resource_group.res_group.name

  ip_configuration {
    name                          = "broker-internal${count.index}"
    subnet_id                     = azurerm_subnet.broker_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#################################################################
# Databases
resource "azurerm_subnet" "db_subnet" {
  name                 = "db_subnet"
  resource_group_name  = azurerm_resource_group.res_group.name
  virtual_network_name = azurerm_virtual_network.virt-network.name
  address_prefixes     = [var.db_subnet_private]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# Allow Scale set VMs access through database firewall
resource "azurerm_postgresql_flexible_server_firewall_rule" "db-firewall-rule" {
  name             = "db-firewall-rule"
  server_id        = azurerm_postgresql_flexible_server.broker_database.id
  start_ip_address = "10.0.1.0"
  end_ip_address   = "10.0.1.254"
}

####################################################################
# Remote Desktop 

resource "azurerm_subnet" "desktop_subnet" {
  name                 = "desktop-subnet"
  resource_group_name  = azurerm_resource_group.res_group.name
  virtual_network_name = azurerm_virtual_network.virt-network.name
  address_prefixes     = [var.desktop_subnet_private]
}

resource "azurerm_public_ip" "desktop-ip" {
  location            = var.region
  name                = "desktop-ip"
  resource_group_name = azurerm_resource_group.res_group.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "desktop-nic" {
  name                = "desktop-nic"
  location            = var.region
  resource_group_name = azurerm_resource_group.res_group.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.desktop_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.desktop-ip.id
  }

  tags = {
    Name = "desktop-nic"
  }
}