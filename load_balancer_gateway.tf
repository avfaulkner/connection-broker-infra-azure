resource "azurerm_public_ip" "lb_ip" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.res_group.location
  resource_group_name = azurerm_resource_group.res_group.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb" {
  name                = "LoadBalancer"
  location            = azurerm_resource_group.res_group.location
  resource_group_name = azurerm_resource_group.res_group.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
}

#######################################
# Gateway to LB association
# resource "azurerm_network_interface_backend_address_pool_association" "cmsg_pool" {
#   network_interface_id    = azurerm_network_interface.gateway_nic.id
#   ip_configuration_name   = azurerm_public_ip.gateway-ip.id
#   backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_pool.id
# }

#######################################
# Load Balancer Rules

resource "azurerm_lb_rule" "inbound_pcoip" {
  name                           = "inbound-pcoip"
  resource_group_name            = azurerm_resource_group.res_group.name
  loadbalancer_id                = azurerm_lb.lb.id
  frontend_ip_configuration_name = "PublicIPAddress"
  protocol                       = "Tcp"
  frontend_port                  = "4172"
  backend_port                   = "4172"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_backend_pool.id
}

resource "azurerm_lb_rule" "inbound_leostream" {
  name                           = "inbound-leostream"
  resource_group_name            = azurerm_resource_group.res_group.name
  loadbalancer_id                = azurerm_lb.lb.id
  frontend_ip_configuration_name = "PublicIPAddress"
  protocol                       = "Tcp"
  frontend_port                  = "60443"
  backend_port                   = "60443"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_backend_pool.id
}

resource "azurerm_lb_rule" "inbound_leostream2" {
  name                           = "inbound-leostream2"
  resource_group_name            = azurerm_resource_group.res_group.name
  loadbalancer_id                = azurerm_lb.lb.id
  frontend_ip_configuration_name = "PublicIPAddress"
  protocol                       = "Tcp"
  frontend_port                  = "443"
  backend_port                   = "443"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_backend_pool.id
}