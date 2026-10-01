# Resource Group
resource "azurerm_resource_group" "vnet_rg" {
	name 	 = "vnet-rg-eastus"
	location = "eastus"
}

# Production Virtual Network in EastUS
# This resource will be deployed successfully because it meets policy requirements
resource "azurerm_virtual_network" "prod_vnet" {
	name			= "prod-vnet"
	location		= azurerm_resource_group.vnet_rg.location	
	resource_group_name	= azurerm_resource_group.vnet_rg.name
	address_space		= ["10.0.0.0/16"]

	tags = {
		Environment 	= "Production"
	}
}

# Development Virtual Network in WestUS 
# This resource will fail deployment because it does not meet location requirements defined in the policy
resource "azurerm_virtual_network" "dev_vnet" {
	name 			= "dev-vnet"
	location		= "westus"
	resource_group_name	= azurerm_resource_group.vnet_rg.name
	address_space		= ["10.1.0.0/16"]

	tags = {
		Environment	= "Development"
	}
}

# Staging Virtual Network in EastUS2
# This resource will fail deployment because it does not meet tag requirements defined in the policy
resource "azurerm_virtual_network" "stg_vnet" {
	name			= "stg-vnet"
	location		= azurerm_resource_group.vnet_rg.location
	resource_group_name	= azurerm_resource_group.vnet_rg.name
	address_space		= ["10.2.0.0/16"]
}
