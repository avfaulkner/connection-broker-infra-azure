
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

resource "azurerm_public_ip" "broker_pub_ip0" {
  location            = var.region
  name                = "broker_pub_ip0"
  resource_group_name = azurerm_resource_group.res_group.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "broker_nic0" {
  name                = "broker-nic0"
  location            = azurerm_resource_group.res_group.location
  resource_group_name = azurerm_resource_group.res_group.name

  ip_configuration {
    name                          = "broker-nic0"
    subnet_id                     = azurerm_subnet.broker_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.broker_pub_ip0.id
  }
}

#############
resource "azurerm_public_ip" "broker_pub_ip1" {
  location            = var.region
  name                = "broker_pub_ip1"
  resource_group_name = azurerm_resource_group.res_group.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "broker_nic1" {
  name                = "broker-nic1"
  location            = azurerm_resource_group.res_group.location
  resource_group_name = azurerm_resource_group.res_group.name

  ip_configuration {
    name                          = "broker-nic1"
    subnet_id                     = azurerm_subnet.broker_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.broker_pub_ip1.id
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

# Public IP is for testing/demo only and will be removed
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

####################################################################
# Remote gateway 

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "gateway-subnet"
  resource_group_name  = azurerm_resource_group.res_group.name
  virtual_network_name = azurerm_virtual_network.virt-network.name
  address_prefixes     = [var.gateway_subnet]
}

resource "azurerm_public_ip" "gateway-ip" {
  location            = var.region
  name                = "gateway-ip"
  resource_group_name = azurerm_resource_group.res_group.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "gateway_nic" {
  name                = "gateway-nic"
  location            = azurerm_resource_group.res_group.location
  resource_group_name = azurerm_resource_group.res_group.name

  ip_configuration {
    name                          = "gateway-internal"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

####################################################################
# Bastion

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "bastion_subnet"
  resource_group_name  = azurerm_resource_group.res_group.name
  virtual_network_name = azurerm_virtual_network.virt-network.name
  address_prefixes     = [var.bastion_subnet]
}

resource "azurerm_public_ip" "bastion_pub_ip" {
  name                = "bastion-pub-ip"
  resource_group_name = azurerm_resource_group.res_group.name
  location            = azurerm_resource_group.res_group.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "bastion_nic" {
  name                = "bastion-nic"
  location            = azurerm_resource_group.res_group.location
  resource_group_name = azurerm_resource_group.res_group.name

  ip_configuration {
    name                          = "bastion"
    subnet_id                     = azurerm_subnet.bastion_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion_pub_ip.id
  }
}