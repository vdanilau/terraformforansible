output "rg_name" {
  value = module.azure_resource_group.rg_name_output
}

output "key_vault_id" {
  value = module.azure_key_vault.key_vault_id_output
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "object_id" {
  value = data.azurerm_client_config.current.object_id
}