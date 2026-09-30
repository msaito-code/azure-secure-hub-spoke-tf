# 5. Assign the Allowed Locations policy to the Production Management Group
resource "azurerm_management_group_policy_assignment" "audit_location_prod" {
	name			= "assign-allowed-loc-prod"
	management_group_id	= azurerm_management_group.prod_mg.id
	policy_definition_id	= azurerm_policy_definition.allowed_locations.id
	display_name		= "Enforce Allowed Locations in Production"
	description		= "Ensures resources in Production are only deployed in allowed regions"

	parameters = jsonencode ({
		allowedLocations = {
			value = ["eastus", "eastus2"]
		}
	})
}
