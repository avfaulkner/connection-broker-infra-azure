# # server security group for remote hosts
resource "azurerm_network_security_group" "desktop-sg" {
  name                = "desktop-sg"
  location            = var.region
  resource_group_name = azurerm_resource_group.res_group.name

  tags = {
    Name = "remote-host-sg"
  }
}

# Security group rules
# Inbound RDP
resource "azurerm_network_security_rule" "desktop-rdp" {
  name                        = "desktop-rdp"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.res_group.name
  network_security_group_name = azurerm_network_security_group.desktop-sg.name
}


# Inbound Leostream
resource "azurerm_network_security_rule" "desktop-leostream" {
  name                        = "desktop-leostream"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = azurerm_subnet.broker_subnet.address_prefix
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.res_group.name
  network_security_group_name = azurerm_network_security_group.desktop-sg.name
}

# Inbound PCoIP
resource "azurerm_network_security_rule" "desktop-pcoip" {
  name                        = "desktop-pcoip"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "4172"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.res_group.name
  network_security_group_name = azurerm_network_security_group.desktop-sg.name
}

# Outbound connections
resource "azurerm_network_security_rule" "desktop-outbound" {
  name                        = "desktop-outbound"
  priority                    = 400
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.res_group.name
  network_security_group_name = azurerm_network_security_group.desktop-sg.name
}

# Connect the security group to the subnet
resource "azurerm_subnet_network_security_group_association" "desktop-sg-assoc" {
  subnet_id                 = azurerm_subnet.desktop_subnet.id
  network_security_group_id = azurerm_network_security_group.desktop-sg.id
}

