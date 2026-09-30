# 17. Create a Route Table for the Spokes
resource "azurerm_route_table" "spoke_rt" {
	name				= "rt-spokes-to-firewall"
	location			= azurerm_resource_group.portfolio_rg.location
	resource_group_name		= azurerm_resource_group.portfolio_rg.name
	bgp_route_propagation_enabled 	= true

	tags = {
		Enviroment = "Portfolio"
		Role = "Networking"
	}
}

# 18. Create the User Defined Route (UDR) pointing to the Firewall
resource "azurerm_route" "default_to_firewall" {
	name			= "udr-default-to-firewall"
	resource_group_name	= azurerm_resource_group.portfolio_rg.name
	route_table_name	= azurerm_route_table.spoke_rt.name
	address_prefix		= "0.0.0.0/0"
	next_hop_type		= "VirtualAppliance"
	next_hop_in_ip_address	= azurerm_firewall.hub_firewall.ip_configuration[0].private_ip_address
}

# 19. Associate Route Table with Spoke 1 Subnet
resource "azurerm_subnet_route_table_association" "spoke1_rt_assoc" {
	subnet_id	= azurerm_subnet.spoke1_subnet.id
	route_table_id	= azurerm_route_table.spoke_rt.id
}

#20. Associate Route Table with Sopke 2 Subnet
resource "azurerm_subnet_route_table_association" "spoke2_rt_assoc" {
	subnet_id	= azurerm_subnet.spoke2_subnet.id
	route_table_id	= azurerm_route_table.spoke_rt.id
}
