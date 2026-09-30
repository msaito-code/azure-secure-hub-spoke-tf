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

# 8. Assign the Baseline Governance Initiative to Production
resource "azurerm_management_group_policy_assignment" "prod_baseline_governance" {
	name			= "assign-baseline-prod"
	management_group_id	= azurerm_management_group.org_prod_mg.id
	policy_definition_id	= azurerm_policy_set_definition.baseline_governance.id
	display_name		= "Enforce Baseline Governance in Production"
	description		= "Ensures production resources adhere to location and taggin standards"

	parameters = jsonencode ({
		allowedLocations = {
			value = ["eastus"] # Stricter location for production
		}
		requiredTagName = {
			value = "Environment"
		}
	})
}
