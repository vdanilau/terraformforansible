resource "azurerm_network_security_group" "azure_nsg" {
  dynamic
  name                = var.name
  location            = var.location
  # dynamic = for_each 
  resource_group_name = var.resource_group_name
}