output "puplic_ip_id_output" {
  value = azurerm_public_ip.public_ip.id
}

output "puplic_ip_ip_address_output" {
  value = azurerm_public_ip.public_ip.ip_address
}