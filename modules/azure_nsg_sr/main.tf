resource "azurerm_network_security_rule" "azure_nsg_sr" {

  dynamic "security_rule" {
    for_each = var.nsg_rules
    iterator = set
    content {
    network_security_group_name = set.value[network_security_group_name]
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