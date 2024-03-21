# all network azure cloud provider
variable "tag_name" {
  type= string 
  default= "gbodje-dev"
}

variable "resource_group_name" {
  type    = string
  default = "gbodje-resource-group"
}

variable "location" {
  type    = string
  default = "West Europe"
}

variable "storage_account_name" {
  type    = string
  default = "gbodje-storage"
}

variable "vnet_name" {
  type    = string
  default = "gbodje-vnet"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type    = list(string)
  default = ["gbodje-public", "gbodje-private"]
}

variable "subnet_address_prefix" {
  type    = list(string)
  default = ["10.0.0.0/27", "10.0.0.32/27"]
}

variable "pip_name" {
  type    = string
  default = "gbodje-pip"
}

variable "nsg_name" {
  type    = string
  default = "gbodje-nsg"
}

variable "nic_name" {
  type    = string
  default = "gbodje-nic"
}

variable "security_rules" {
  # Define a list of objects for security rules
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    source_address_prefix      = string
    destination_address_prefix = string
    destination_port_range     = string
    protocol                   = string
    access                     = string
  }))

  # Example configuration with SSH, HTTP, and HTTPS rules
  default = [
    {
      name                       = "AllowSSH"
      priority                   = 100
      direction                  = "Inbound"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      destination_port_range     = "22"
      protocol                   = "Tcp"
      access                     = "Allow"
    },
    {
      name                       = "AllowHTTP"
      priority                   = 200
      direction                  = "Inbound"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      destination_port_range     = "80"
      protocol                   = "Tcp"
      access                     = "Allow"
    },
    {
      name                       = "AllowHTTPS"
      priority                   = 300
      direction                  = "Inbound"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      protocol                   = "Tcp"
      access                     = "Allow"
    }
  ]
}
