# # server security group for remote hosts
resource "azurerm_network_security_group" "broker-sg" {
  name                = "broker-sg"
  location            = var.region
  resource_group_name = azurerm_resource_group.res_group.name

  tags = {
    Name = "remote-host-sg"
  }
}

# Security group rules
# Inbound SSH
resource "azurerm_network_security_rule" "broker-ssh" {
  name                        = "broker-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "22"
  destination_port_range      = "22"
  source_address_prefix       = azurerm_subnet.broker_subnet.address_prefix
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.res_group.name
  network_security_group_name = azurerm_network_security_group.broker-sg.name
}


# Inbound Leostream
resource "azurerm_network_security_rule" "broker-leostream" {
  name                        = "broker-leostream"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "60443"
  destination_port_range      = "60443"
  source_address_prefix       = azurerm_subnet.desktop_subnet.address_prefix
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.res_group.name
  network_security_group_name = azurerm_network_security_group.broker-sg.name
}

# Inbound PCoIP
resource "azurerm_network_security_rule" "broker-pcoip" {
  name                        = "broker-pcoip"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "4172"
  destination_port_range      = "4172"
  source_address_prefix       = azurerm_subnet.broker_subnet.address_prefix
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.res_group.name
  network_security_group_name = azurerm_network_security_group.broker-sg.name
}

# Outbound connections
resource "azurerm_network_security_rule" "broker-outbound" {
  name                        = "broker-outbound"
  priority                    = 400
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.res_group.name
  network_security_group_name = azurerm_network_security_group.broker-sg.name
}

# Connect the security group to the subnet
resource "azurerm_subnet_network_security_group_association" "broker-sg-assoc" {
  subnet_id                 = azurerm_subnet.broker_subnet.id
  network_security_group_id = azurerm_network_security_group.broker-sg.id
}