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

variable "nsg_rule" {
  
}

# variable "security_rule" {
  
# }