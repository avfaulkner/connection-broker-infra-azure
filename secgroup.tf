# # server security group for remote hosts
resource "azurerm_network_security_group" "remote-host-sg" {
  name                = "remote-host-sg"
  location            = var.region
  resource_group_name = azurerm_resource_group.res_group.name

  tags = {
    Name = "remote-host-sg"
  }
}

# # inbound ssh access
# resource "azure_security_group_rule" "ssh-in" {
#   name                       = "ssh access"
#   type                       = "Inbound"
#   action                     = "Allow"
#   priority                   = 200
#   source_address_prefix      = var.ssh_cidr_blocks
#   source_port_range          = "*"
#   destination_address_prefix = azure_instance.remote-host.ip_address 
#   destination_port_range     = "22"
#   protocol                   = "TCP"
#   security_group_names = azurerm_network_security_group.remote-host-sg.name
# }

# # https inbound
# resource "azure_security_group_rule" "https-in" {
#   name                       = "https-in"
#   type                       = "Inbound"
#   action                     = "Allow"
#   priority                   = 200
#   source_address_prefix      = var.ssh_cidr_blocks
#   source_port_range          = "*"
#   destination_address_prefix = azure_instance.remote-host.ip_address 
#   destination_port_range     = "443"
#   protocol                   = "TCP"
#   security_group_names = azurerm_network_security_group.remote-host-sg.name
# }

# # https outbound
# resource "azure_security_group_rule" "https-out" {
#   name                       = "https access"
#   type                       = "Outbound"
#   action                     = "Allow"
#   priority                   = 200
#   source_address_prefix      = azure_instance.remote-host.ip_address
#   source_port_range          = "*"
#   destination_address_prefix = var.destination_address_prefix
#   destination_port_range     = "443"
#   protocol                   = "TCP"
#   security_group_names = azurerm_network_security_group.remote-host-sg.name
# }

# # http outbound
# resource "azure_security_group_rule" "http-out" {
#   name                       = "http access"
#   type                       = "Outbound"
#   action                     = "Allow"
#   priority                   = 200
#   source_address_prefix      = azure_instance.remote-host.ip_address
#   source_port_range          = "*"
#   destination_address_prefix = var.destination_address_prefix
#   destination_port_range     = "80"
#   protocol                   = "TCP"
#   security_group_names = azurerm_network_security_group.remote-host-sg.name
# }
