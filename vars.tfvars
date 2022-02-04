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
        "instance_count" = "1"
        "public_access" = true
        "my_id" = "sd"
    },
    {
        "instance_name" = "ansible-node01"
        "instance_count" = "1"
        "public_access" = false
        "my_id" = "sd"
    },
    {
        "instance_name" = "ansible-node02"
        "instance_count" = "1"
        "public_access" = false
        "my_id" = "sd"
    }
]