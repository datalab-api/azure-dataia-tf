
# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  lifecycle {
    prevent_destroy = true
    tags = var.tag_name
  }
  # Comments can be added after the closing curly brace of a resource block
}

# Create a storage account
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Comments can explain the purpose of specific arguments
  # This argument defines the type of storage performance tier
  # Here we're using "Standard_LRS" which is locally redundant storage
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a subnet within the virtual network
resource "azurerm_subnet" "subnet" {
  count                = 2
  name                 = var.subnet_name[count.index]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [element(var.subnet_address_prefix, count.index)]
  
}

# Create a public IP address
resource "azurerm_public_ip" "pip" {
  name                = var.pip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  tags = {
    environment = var.tag_name 
    purpose     = "webserver" # Example tag
  }
}

# Create a network security group
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Define security rules in a variable
  # Comments can explain the purpose of the security rule
  # This rule allows SSH traffic from anywhere to any VM within the subnet
  dynamic "security_rule" {
    for_each = var.security_rules
    content {
      name                       = each.value.name
      priority                   = each.value.priority
      direction                  = each.value.direction
      source_address_prefix      = each.value.source_address_prefix
      destination_address_prefix = each.value.destination_address_prefix
      destination_port_range     = each.value.destination_port_range
      protocol                   = each.value.protocol
      access                     = each.value.access
    }
  }
}

# Create a network interface
resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet[1].id # Use index [0] for the first subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
  # Reference the network security group using its ID
  #network_security_group_id = azurerm_network_security_group.nsg.id
}
 