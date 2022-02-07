resource "azurerm_network_security_group" "azure_nsg" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.nsg_rule
    iterator = set
    content {
    name                       = set.value["name"]
    priority                   = set.value["priority"]
    direction                  = set.value["direction"]
    access                     = set.value["access"]
    protocol                   = set.value["protocol"]
    source_port_range          = set.value["source_port_range"]
    destination_port_range     = set.value["destination_port_range"]
    source_address_prefix      = set.value["source_address_prefix"]
    destination_address_prefix = set.value["destination_address_prefix"]
    }
  }
}