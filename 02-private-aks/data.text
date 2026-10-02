# Getting Virtual Network information from proect 01-secure-hub-spoke
data "azurerm_resource_group" "network_rg" {
	name = "rg-secure-network-portfolio"
}

data "azurerm_virtual_network" "spoke1_vnet" {
	name			= "vnet-spoke1-eastus"
	resource_group_name	= data.azurerm_resource_group.network_rg.name
}

data "azurerm_subnet" "spoke1_subnet" {
	name			= "snet-workload-spoke1"
	virtual_network_name	= data.azurerm_virtual_network.spoke1_vnet.name
	resource_group_name	= data.azurerm_resource_group.network_rg.name
}

data "azurerm_virtual_network" "hub_vnet" {
	name			= "vnet-hub-eastus"
	resource_group_name	= data.azurerm_resource_group.network_rg.name
}

data "azurerm_firewall" "hub_firewall" {
	name			= "afw-hub-eastus"
	resource_group_name	= data.azurerm_resource_group.network_rg.name
}
