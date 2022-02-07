# output "network_interface_id_output" {
#   value = azurerm_network_interface.nic.*.id
# }

# output "network_interface_id_output" {
#   value = azurerm_network_interface.nic[*].id
# }

# output "network_interface_id_output" {
#   value = [for o in azurerm_network_interface.nic[*] : o.id]
#   }

# output "network_interface_id_output" {
#   value = tomap({
#     for k, inst in azurerm_network_interface.nic[*] : k => inst.id
#   }) 
# }