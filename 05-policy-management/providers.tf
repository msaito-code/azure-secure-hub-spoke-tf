# 0. Terraform settings and providers
terraform {
	required_providers {
		azurerm = {
			source 	= "hashicorp/azurerm"
			version = "~> 4.0"
		}
	}
}

provider "azurerm" {
	features {}
}
