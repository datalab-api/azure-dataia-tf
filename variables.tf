variable "resource_group_name" {
  type = string
  default = "my-resource-group"
}

variable "resource_group_location" {
  type = string
  default = "West Europe"
}

variable "vnet_name" {
  type = string
  default = "my-vnet"
}

variable "vnet_address_space" {
  type = string
  default = "10.0.0.0/16"
}

