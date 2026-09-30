# 14. The mandatory Firewall Subnet in the Hub
resource "azurerm_subnet" "firewall_subnet" {
	name			= "AzureFirewallSubnet"
	resource_group_name	= azurerm_resource_group.portfolio_rg.name
	virtual_network_name	= azurerm_virtual_network.hub_vnet.name
	address_prefixes	= ["10.0.1.0/26"]
}

# 15. Public IP for the Firewall
resource "azurerm_public_ip" "firewall_pip" {
	name			= "pip-hub-firewall"
	location		= azurerm_resource_group.portfolio_rg.location
	resource_group_name	= azurerm_resource_group.portfolio_rg.name
	allocation_method	= "Static"
	sku			= "Standard"
}

# 16. The Azure Firewall instance
resource "azure_firewall" "hub_firewall" {
	name			= "afw-hub-eastus"
	location		= azurerm_resource_group.portfolio_rg.location
	resource_group_name 	= azurerm_resource_group.portfolio_rg.name
	sku_name		= "AZFW_VNet"
	sku_tier		= "Standard"

	ip_configuration {
		name 			= "configuration"
		subnet_id		= azurerm_subnet.firewall_subnet.id
		public_ip_address_id	= azurerm_public_ip.firewall_pip.id
	}

	tags = {
		Environment 	= "Production"
		Role		= "Security"
	}
}


