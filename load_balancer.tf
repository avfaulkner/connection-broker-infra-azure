resource "azurerm_public_ip" "broker_lb_ip" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.res_group.location
  resource_group_name = azurerm_resource_group.res_group.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "broker_lb" {
  name                = "BrokerLoadBalancer"
  location            = azurerm_resource_group.res_group.location
  resource_group_name = azurerm_resource_group.res_group.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.broker_lb_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "example" {
  loadbalancer_id = azurerm_lb.broker_lb.id
  name            = "BackEndAddressPool"
}
