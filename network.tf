
# Create a virtual network within the resource group
resource "azurerm_virtual_network" "virt-network" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.res_group.name
  location            = azurerm_resource_group.res_group.location
  address_space       = ["10.0.0.0/16"]
}

# Subnets
# Private

resource "azurerm_subnet" "scale-set-subnet-private" {
  name                 = "scale-set-subnet-priv"
  resource_group_name  = azurerm_resource_group.res_group.name
  virtual_network_name = azurerm_virtual_network.virt-network.name
  address_prefixes       = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet-private" {
  name                 = "remote-host-subnet-priv"
  resource_group_name  = azurerm_resource_group.res_group.name
  virtual_network_name = azurerm_virtual_network.virt-network.name
  address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "db-subnet-private" {
  name                 = "db-subnet-private"
  resource_group_name  = azurerm_resource_group.res_group.name
  virtual_network_name = azurerm_virtual_network.virt-network.name
  address_prefixes     = ["10.0.3.0/24"]
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
  start_ip_address = azurerm_subnet.scale-set-subnet-private.address_prefixes
  end_ip_address   = azurerm_subnet.scale-set-subnet-private.address_prefixes
}


# Public
resource "azurerm_subnet" "subnet-public" {
  name                 = "remote-host-subnet-pub"
  resource_group_name  = azurerm_resource_group.res_group.name
  virtual_network_name = azurerm_virtual_network.virt-network.name
  address_prefixes       = ["10.0.4.0/24"]
}

resource "azurerm_public_ip" "remote-host-ip" {
  location = var.region
  name = "remote-host-ip"
  resource_group_name = azurerm_resource_group.res_group.name
  allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "remote-host-nic" {
  name                        = "remote-host-nic"
  location                    = var.region
  resource_group_name         = azurerm_resource_group.res_group.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.subnet-public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.remote-host-ip.id
  }

  tags = {
    Name = "remote-host-nic"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "sg-nic" {
  network_interface_id      = azurerm_network_interface.remote-host-nic.id
  network_security_group_id = azurerm_network_security_group.remote-host-sg.id
}