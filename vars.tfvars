# variable "rg_name" {
#   type = string
#   value = "sdtest"
# }

# variable "location" {
#   type = string
#   value = "eastus2"
# }
index = "01"
infrastructure_name = "sdtest"
location = "eastus2"
address_space = ["10.0.0.0/16"]
vm_count = 3

ansible_vms = [
    {
      "instance_name" = "ansible-master"
      "public_access" = true
      "vm_size"       = "Standard_B1s"
      "instance_count" = "1"        
      "my_id" = "sd"
    },
    {
      "instance_name" = "ansible-node01"
      "public_access" = false
      "vm_size"       = "Standard_B1s"
      "instance_count" = "1"        
      "my_id" = "sd"
    },
    {
      "instance_name" = "ansible-node02"
      "public_access" = false
      "vm_size"       = "Standard_B1s"
      "instance_count" = "1"        
      "my_id" = "sd"
    }
]

nsg_rule = [
    {
      name                       = "allow_inbound_ssh",
      priority                   = "100",
      direction                  = "Inbound",
      access                     = "Allow",
      protocol                   = "TCP",
      source_port_range          = "*",
      destination_port_range     = "443",
      source_address_prefix      = "*",
      destination_address_prefix = "*"
    },
    {
      name                       = "test1234"
      priority                   = "105"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
]