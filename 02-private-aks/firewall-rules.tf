# 8. Firewall Rules for egress traffic to the AKS Instance
resource "azurerm_firewall_network_rule_collection" "aks_required_rules" {
	name			= "aks-egress-rules"
	azure_firewall_name 	= azurerm_firewall.hub_firewall.name
	resource_group_name	= azurerm_resource_group.network_rg.name
	priority		= 200
	action			= "Allow"

	# Core AKS outbound connectivity rules
	rule {
		name			= "aks-api-and-nodes"
		source_addresses	= ["10.1.0.0/24"] # spoke1_subnet
		destination_ports	= ["443", "1194", "9000"]
		protocols		= ["UDP"]
		destination_addresses	= ["*"]
	}

	rule {
		name			= "time-sync-ntp"
		source_addresses	= ["10.1.0.0/24"]
		destination_ports	= ["123"]
		protocols		= ["UDP"]
		destination_addresses	= ["*"]
	}
}
