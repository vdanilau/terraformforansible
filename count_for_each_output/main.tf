terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "2.94.0"
        }
    }
}

provider "azurerm" {
    features {}
}

data "azurerm_client_config" "current" {}

module "azure_resource_group" {
  source = "../modules/azure_rg"
  name = "${var.infrastructure_name}-${var.index}"
  location = var.location
}

module "azure_key_vault" {
  source = "../modules/azure_key_vault"
  name = "${var.infrastructure_name}-kv-${var.index}"
  location = var.location
  resource_group_name = module.azure_resource_group.rg_name_output
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id
}

module "azure_virtual_network" {
    source = "../modules/azure_vnet"
    name = "${var.infrastructure_name}-vnet-${var.index}"
    location = var.location
    address_space = var.address_space
    resource_group_name = module.azure_resource_group.rg_name_output
}

module "azure_subnet" {
    source = "../modules/azure_subnet"
    name = "${var.infrastructure_name}-ansiblevm-${var.index}"
    address_prefix = [cidrsubnet(element(var.address_space, 0), 8, 0)]
    virtual_network_name = module.azure_virtual_network.virtual_network_name_output
    resource_group_name = module.azure_resource_group.rg_name_output
}

module "azure_public_ip" {
    source = "../modules/azure_public_ip"
    name = "${var.infrastructure_name}-pip-${var.index}"
    location = var.location
    resource_group_name = module.azure_resource_group.rg_name_output
}

module "azure_network_interface" {
    for_each = { for x in var.ansible_vms : x.instance_name => x }
    # for_each = { for x in var.ansible_vms : x.my_id => x }    
    source = "../modules/azure_network_interface"
    name = "${var.infrastructure_name}-nic-${var.index}-${lookup(each.value, "instance_name")}"
    location = var.location
    subnet_id = module.azure_subnet.subnet_id_output
    resource_group_name = module.azure_resource_group.rg_name_output
    public_ip_address_id = lookup(each.value, "public_access") == true ? module.azure_public_ip.puplic_ip_id_output : ""
}

# module "azure_network_interface" {
#     # for_each = { for x in var.ansible_vms : x.instance_name => x }
#     # for_each = { for x in var.ansible_vms : x.my_id => x }
#     count = length(var.ansible_vms)
#     source = "../modules/azure_network_interface"
#     name = "${var.infrastructure_name}-nic-${var.index}-${ansible_vms[count.index].instance_name}"
#     location = var.location
#     subnet_id = module.azure_subnet.subnet_id_output
#     resource_group_name = module.azure_resource_group.rg_name_output
#     public_ip_address_id = "1233" #each.value.public_access == true ? module.azure_public_ip.puplic_ip_id_output : ""
# }