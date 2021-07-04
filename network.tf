
# Create a virtual network within the resource group
resource "azurerm_virtual_network" "virt-network" {
  name                = "virtual-network"
  resource_group_name = azurerm_resource_group.res_group.name
  location            = azurerm_resource_group.res_group.location
  address_space       = var.virtual_network
}

# App Gateway subnets
resource "azurerm_subnet" "gateway-subnet-frontend" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.res_group.name
  virtual_network_name = azurerm_virtual_network.virt-network.name
  address_prefixes     = [var.gateway-subnet-frontend]
}


# Broker VMs
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



# Database
resource "azurerm_subnet" "db-subnet-private" {
  name                 = "db-subnet-private"
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


# Public
# resource "azurerm_subnet" "subnet-public" {
#   name                 = "desktop-subnet-pub"
#   resource_group_name  = azurerm_resource_group.res_group.name
#   virtual_network_name = azurerm_virtual_network.virt-network.name
#   address_prefixes     = ["10.0.4.0/24"]
# }


# Remote Desktop Networking

resource "azurerm_subnet" "desktop-subnet-private" {
  name                 = "desktop-subnet-priv"
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
    subnet_id                     = azurerm_subnet.desktop-subnet-private.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.desktop-ip.id
  }

  tags = {
    Name = "desktop-nic"
  }
}

# Connect the security group to the subnet
resource "azurerm_subnet_network_security_group_association" "desktop-sg-assoc" {
  subnet_id                 = azurerm_subnet.desktop-subnet-private.id
  network_security_group_id = azurerm_network_security_group.desktop-sg.id
}

