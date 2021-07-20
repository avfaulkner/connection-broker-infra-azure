resource "azurerm_public_ip" "lb_broker_ip" {
  name                = "PublicIPForLBB"
  location            = azurerm_resource_group.res_group.location
  resource_group_name = azurerm_resource_group.res_group.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb_broker" {
  name                = "LoadBalancerBroker"
  location            = azurerm_resource_group.res_group.location
  resource_group_name = azurerm_resource_group.res_group.name

  frontend_ip_configuration {
    name                 = "PublicIPAddressLBB"
    public_ip_address_id = azurerm_public_ip.lb_broker_ip.id
    private_ip_address_version = "IPv4"
  }
}

resource "azurerm_lb_backend_address_pool" "lbb_backend_pool" {
  loadbalancer_id = azurerm_lb.lb_broker.id
  name            = "BackEndAddressPoolLBB"
}

#######################################
# Broker to LB association
resource "azurerm_network_interface_backend_address_pool_association" "broker_pool" {
  network_interface_id    = azurerm_network_interface.broker_nic0.id
  ip_configuration_name   = "broker-nic0"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lbb_backend_pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "broker_pool2" {
  network_interface_id    = azurerm_network_interface.broker_nic1.id
  ip_configuration_name   = "broker-nic1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lbb_backend_pool.id
}

#######################################
# Load Balancer Rules

resource "azurerm_lb_rule" "lbb_inbound_http" {
  name                           = "inbound-http"
  resource_group_name            = azurerm_resource_group.res_group.name
  loadbalancer_id                = azurerm_lb.lb_broker.id
  frontend_ip_configuration_name = "PublicIPAddressLBB"
  protocol                       = "Tcp"
  frontend_port                  = "80"
  backend_port                   = "80"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lbb_backend_pool.id
}

resource "azurerm_lb_rule" "lbb_inbound_https" {
  name                           = "inbound-https"
  resource_group_name            = azurerm_resource_group.res_group.name
  loadbalancer_id                = azurerm_lb.lb_broker.id
  frontend_ip_configuration_name = "PublicIPAddressLBB"
  protocol                       = "Tcp"
  frontend_port                  = "443"
  backend_port                   = "443"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lbb_backend_pool.id
}

resource "azurerm_lb_rule" "lbb_inbound_leostream" {
  name                           = "inbound-leostream"
  resource_group_name            = azurerm_resource_group.res_group.name
  loadbalancer_id                = azurerm_lb.lb_broker.id
  frontend_ip_configuration_name = "PublicIPAddressLBB"
  protocol                       = "Tcp"
  frontend_port                  = "60443"
  backend_port                   = "60443"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lbb_backend_pool.id
}

resource "azurerm_lb_rule" "lbb_inbound_leostream_agent" {
  name                           = "inbound-leostream-agent"
  resource_group_name            = azurerm_resource_group.res_group.name
  loadbalancer_id                = azurerm_lb.lb_broker.id
  frontend_ip_configuration_name = "PublicIPAddressLBB"
  protocol                       = "TCP"
  frontend_port                  = "8080"
  backend_port                   = "8080"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lbb_backend_pool.id
}