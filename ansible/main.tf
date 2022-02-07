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
  source   = "../modules/azure_rg"
  name     = "${var.infrastructure_name}-${var.index}"
  location = var.location
}

module "azure_key_vault" {
  source              = "../modules/azure_key_vault"
  name                = "${var.infrastructure_name}-kv-${var.index}"
  location            = var.location
  resource_group_name = module.azure_resource_group.rg_name_output
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
}

module "azure_virtual_network" {
    source              = "../modules/azure_vnet"
    name                = "${var.infrastructure_name}-vnet-${var.index}"
    location            = var.location
    address_space       = var.address_space
    resource_group_name = module.azure_resource_group.rg_name_output
}

module "azure_subnet" {
    source               = "../modules/azure_subnet"
    name                 = "${var.infrastructure_name}-ansiblevm-${var.index}"
    address_prefix       = [cidrsubnet(element(var.address_space, 0), 8, 0)]
    virtual_network_name = module.azure_virtual_network.virtual_network_name_output
    resource_group_name  = module.azure_resource_group.rg_name_output
}

module "azure_public_ip" {
    source              = "../modules/azure_public_ip"
    name                = "${var.infrastructure_name}-pip-${var.index}"
    location            = var.location
    resource_group_name = module.azure_resource_group.rg_name_output
}

module "azure_network_interface" {    
    source               = "../modules/azure_network_interface"
    for_each             = { for x in var.ansible_vms : x.instance_name => x }
    name                 = "${var.infrastructure_name}-nic-${var.index}-${lookup(each.value, "instance_name")}"
    location             = var.location
    subnet_id            = module.azure_subnet.subnet_id_output
    resource_group_name  = module.azure_resource_group.rg_name_output
    public_ip_address_id = lookup(each.value, "public_access") == true ? module.azure_public_ip.puplic_ip_id_output : ""
}

module "azure_linux_vm" {
    source              = "../modules/azure_linux_vm"
    for_each            = { for x in var.ansible_vms : x.instance_name => x }
    name                = lookup(each.value, "instance_name")
    location            = var.location
    vm_size             = lookup(each.value, "vm_size")
    nic_id              = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${module.azure_resource_group.rg_name_output}/providers/Microsoft.Network/networkInterfaces/${var.infrastructure_name}-nic-${var.index}-${lookup(each.value, "instance_name")}"
    resource_group_name = module.azure_resource_group.rg_name_output
    depends_on          = [module.azure_network_interface]
}

module "azure_nsg_vm" {
    source = "../modules/azure_nsg_with_sr"
    name = "${var.infrastructure_name}-nsg-vm-${var.index}"
    location = var.location
    nsg_rule = var.nsg_rule_vm
    resource_group_name = module.azure_resource_group.rg_name_output
}

module "azure_nsg_db" {
    source              = "../modules/azure_nsg_with_sr"
    name                = "${var.infrastructure_name}-nsg-db-${var.index}"
    location            = var.location
    nsg_rule            = var.nsg_rule_db
    resource_group_name = module.azure_resource_group.rg_name_output
}

resource "azurerm_subnet_network_security_group_association" "vm_subnet_to_nsg" {
  subnet_id                 = module.azure_subnet.subnet_id_output
  network_security_group_id = module.azure_nsg_vm.nsg_id_output
}

# module "azure_nsg" {
#     source              = "../modules/azure_nsg"   
#     name                = var.nsg_rules
#     location            = var.location
#     resource_group_name = module.azure_resource_group.rg_name_output
# }
# module "azure_nsg_db" {
#     source = "../modules/azure_nsg"
#     name = var.nsg_rules
#     location = var.location
#     resource_group_name = module.azure_resource_group.rg_name_output
# }

# module "azure_nsg_rule_db"{
#     source = "../modules/azure_nsg"
#     for_each = var.nsg_rules
# }


