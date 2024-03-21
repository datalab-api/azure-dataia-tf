output "resource_group_id" {
  value       = azurerm_resource_group.rg.id
  description = "The ID of the Azure resource group"
}

output "storage_account_id" {
  value       = azurerm_storage_account.storage.id
  description = "The ID of the Azure storage account"
}

output "virtual_network_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The ID of the Azure virtual network"
}

output "subnet_id" {
  value = {
    for subnet in azurerm_subnet.subnet : subnet.id => subnet.name
  }
  description = "A map of subnet names to their IDs"
}

output "public_ip_address_id" {
  value       = azurerm_public_ip.pip.id
  description = "The ID of the Azure public IP address"
}

output "network_security_group_id" {
  value       = azurerm_network_security_group.nsg.id
  description = "The ID of the Azure network security group"
}

output "network_interface_id" {
  value       = azurerm_network_interface.nic.id
  description = "The ID of the Azure network interface"
}
