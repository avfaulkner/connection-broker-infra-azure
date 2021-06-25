# layer 7 load balancer and associated resources

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.virt-network.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.virt-network.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.virt-network.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.virt-network.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.virt-network.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.virt-network.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.virt-network.name}-rdrcfg"
}

resource "azurerm_subnet" "gateway-subnet-frontend" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.res_group.name
  virtual_network_name = azurerm_virtual_network.virt-network.name
  address_prefixes     = [var.gateway-subnet-frontend]
}

resource "azurerm_subnet" "scale-set-subnet-backend" {
  name                 = "backend"
  resource_group_name  = azurerm_resource_group.res_group.name
  virtual_network_name = azurerm_virtual_network.virt-network.name
  address_prefixes     = [var.broker_subnet]
}

resource "azurerm_public_ip" "appgw-pub-ip" {
  name                = "appgw-public-ip"
  resource_group_name = azurerm_resource_group.res_group.name
  location            = azurerm_resource_group.res_group.location
  allocation_method   = "Dynamic"
}

resource "azurerm_application_gateway" "appgateway" {
  name                = "appgateway"
  resource_group_name = azurerm_resource_group.res_group.name
  location            = azurerm_resource_group.res_group.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.gateway-subnet-frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw-pub-ip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}


