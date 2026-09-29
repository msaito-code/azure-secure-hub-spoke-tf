# 0. Terraform and provider settings
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

# 1. Resource Group
resource "azurerm_resource_group" "portfolio_rg" {
	name		= "rg-secure-network-portfolio"
	location	= "East US"
}
