variable "infrastructure_name" {
  type = string
}

variable "location" {
  type = string
}

variable "index" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "vm_count" {
  type = string
}

variable "ansible_vms" {

}

variable "nsg_rule_vm" {
  
}

variable "nsg_rule_db" {
  
}

variable "allocation_method" {
  
}

# variable "user_data" {
  
# }

# variable "security_rule" {
  
# }