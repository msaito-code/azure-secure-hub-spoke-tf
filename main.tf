terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
			version = "~> 4.0"
		}
	}
}

provider "azurerm" {
	features {}
}

resource "azurerm_resource_group" "portfolio_rg" {
	name		= "rg-secure-network-portfolio"
	location	= "East US"
}

resource "azurerm_virtual_network" "hub_vnet" {
	name			= "vnet-hub-eastus"
	location		= azurerm_resource_group.portfolio_rg.location
	resource_group_name 	= azurerm_resource_group.portfolio_rg.name
	address_space 		= ["10.0.0.0/16"]

	tags = {
		Environemnt 	= "Portfolio"
		Role 		= "Hub"
	}
} 
