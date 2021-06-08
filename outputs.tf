output "resource_group" {
    value = azurerm_resource_group.res_group.id
}

output "application_gateway" {
    value = azurerm_application_gateway.appgateway
}

