# 11. Network Security Group for Spoke Workloads
resource "azurerm_network_security_group" "spoke_nsg" {
	name 			= "nsg-spoke-workloads"
	location		= azurerm_resource_group.network_rg.location
	resource_group_name	= azurerm_resource_group.network_rg.name

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
