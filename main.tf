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

# 2. Hub Virtual Network
resource "azurerm_virtual_network" "hub_vnet" {
	name			= "vnet-hub-eastus"
	location		= azurerm_resource_group.portfolio_rg.location
	resource_group_name 	= azurerm_resource_group.portfolio_rg.name
	address_space 		= ["10.0.0.0/16"]

	tags = {
		Environemnt 	= "Production"
		Role 		= "Hub"
	}
} 

# 3. Spoke 1 Virtual Network
resource "azurerm_virtual_network" "spoke1_vnet" {
	name			= "vnet-spoke1-eastus"
	location		= azurerm_resource_group.portfolio_rg.location
	resource_group_name	= azurerm_resource_group.portfolio_rg.name
	address_space		= ["10.1.0.0/16"]

	tags = {
		Environment 	= "Production"
		Role 		= "Spoke"
	}
}

# 4. Spoke 2 Virtual Network
resource "azurerm_virtual_network" "spoke2_vnet" {
	name 			= "vnet-spoke2-eastus"
	location		= azurerm_resource_group.portfolio_rg.location
	resource_group_name	= azurerm_resource_group.portfolio_rg.name
	address_space		= ["10.2.0.0/16"]

	tags = {
		Environment = "Production"
		Role = "Spoke"
	}
}

# 5. Peering: Hub to Spoke 1
resource "azurerm_virtual_network_peering" "hub_to_spoke1" {
	name 				= "peer-hub-to-spoke1"
	resource_group_name		= azurerm_resource_group.portfolio_rg.name
	virtual_network_name		= azurerm_virtual_network.hub_vnet.name
	remote_virtual_network_id	= azurerm_virtual_network.spoke1_vnet.id
	allow_virtual_network_access	= true
	allow_forwarded_traffic		= true
}

# 6. Peering: Spoke 1 to Hub
resource "azurerm_virtual_network_peering" "spoke1_to_hub" {
	name				= "peer-spoke1-to-vnet"
	resource_group_name		= azurerm_resource_group.portfolio_rg.name
	virtual_network_name		= azurerm_virtual_network.spoke1_vnet.name
	remote_virtual_network_id	= azurerm_virtual_network.hub_vnet.id
	allow_virtual_network_access	= true
	allow_forwarded_traffic		= true
}

# 7. Peering: Hub to Spoke 2
resource "azurerm_virtual_network_peering" "hub_to_spoke2" {
	name				= "peer-hub-to-spoke2"
	resource_group_name		= azurerm_resource_group.portfolio_rg.name
	virtual_network_name		= azurerm_virtual_network.hub_vnet.name
	remote_virtual_network_id	= azurerm_virtual_network.spoke2_vnet.id
	allow_virtual_network_access	= true
	allow_forwarded_traffic		= true
}


# 8. Peering: Spoke 2 to Hub
resource "azurerm_virtual_network_peering" "spoke2_to_hub" {
	name				= "peer-spoke2-to-vnet"
	resource_group_name		= azurerm_resource_group.portfolio_rg.name
	virtual_network_name		= azurerm_virtual_network.spoke2_vnet.name
	remote_virtual_network_id	= azurerm_virtual_network.hub_vnet.id
	allow_virtual_network_access	= true
	allow_forwarded_traffic		= true
}

# 9. Spoke 1 Workload Subnet
resource "azurerm_subnet" "spoke1_subnet" {
	name 			= "snet-workload-spoke1"
	resource_group_name	= azurerm_resource_group.portfolio_rg.name
	virtual_network_name	= azurerm_virtual_network.spoke1_vnet.name
	address_prefixes	= ["10.1.0.0/24"]
}

# 10. Spoke 2 Workload Subnet
resource "azurerm_subnet" "spoke2_subnet" {
	name			= "snet-workload-spoke2"
	resource_group_name	= azurerm_resource_group.portfolio_rg.name
	virtual_network_name	= azurerm_virtual_network.spoke2_vnet.name
	address_prefixes	= ["10.2.0.0/24"]
}

# 11. Network Security Group for Spoke Workloads
resource "azurerm_network_security_group" "spoke_nsg" {
	name 			= "nsg-spoke-workloads"
	location		= azurerm_resource_group.portfolio_rg.location
	resource_group_name	= azurerm_resource_group.portfolio_rg.name

	# Security Rule: Explicitly Deny Direct RDP/SSH from the internet
	security_rule {
		name				= "Deny-Internet-Admin-Inbound"
		priority			= 100
		direction			= "Inbound"
		access				= "Deny"
		protocol			= "Tcp"
		source_port_range		= "*"
		destination_port_ranges		= ["22", "3389"]
		source_address_prefix		= "Internet"
		destination_address_prefix	= "*"
	}

	tags = {
		Environment	= "Production"
		Role		= "Security"
	}
}

# 12. Associate NSG with Spoke 1 Subnet
resource "azurerm_subnet_network_security_group_association" "spoke1_nsg_assoc" {
	subnet_id			= azurerm_subnet.spoke1_subnet.id
	network_security_group_id	= azurerm_network_security_group.spoke_nsg.id
}

# 13. Associate NSG with Spoke 2 Subnet
resource "azurerm_subnet_network_security_group_association" "spoke2_nsg_assoc" {
	subnet_id			= azurerm_subnet.spoke2_subnet.id
	network_security_group_id	= azurerm_network_security_group.spoke_nsg.id
}
