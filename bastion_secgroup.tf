# bastion security group
resource "azurerm_network_security_group" "bastion-sg" {
  name                = "bastion-sg"
  location            = var.region
  resource_group_name = azurerm_resource_group.res_group.name

  tags = {
    Name = "bastion-sg"
  }
}

# Security group rules
# Inbound SSH
resource "azurerm_network_security_rule" "bastion-ssh" {
  name                        = "bastion-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.ssh_cidr_blocks
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.res_group.name
  network_security_group_name = azurerm_network_security_group.bastion-sg.name
}


# Outbound connections
resource "azurerm_network_security_rule" "bastion-outbound" {
  name                        = "bastion-outbound"
  priority                    = 400
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.res_group.name
  network_security_group_name = azurerm_network_security_group.bastion-sg.name
}

# Connect the security group to the subnet
resource "azurerm_subnet_network_security_group_association" "bastion-sg-assoc" {
  subnet_id                 = azurerm_subnet.bastion_subnet.id
  network_security_group_id = azurerm_network_security_group.bastion-sg.id
}