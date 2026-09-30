# 4. Custom Policy Definition: Restrict allowed Azure Locations
resource "azurerm_policy_definition" "allowed_locations" {
	name		= "allowed-azure-locations"
	policy_type	= "Custom"
	mode		= "All"
	display_name	= "Allowed Azure Location"
	description	= "This policy restricts deployment of resources to specified allowed Azure regions"

	metadata = jsonencode ({
		category = "Governance"
	})

	policy_rule = jsonencode ({
		if = {
			not = {
				field 	= "location"
				in	= ["parameters(allowedLocations)"]
			}
		}
		then = {
			effect = "deny"
		}
	})

	parameters = jsonencode ({
		allowedLocations = {
			type	 = "Array"
			metadata = {
				displayName	= "Allowed Locations"
				description	= "The list of allowed locations for resources"
			}
			defaultValue = ["eastus", "eastus2"]
		}
	})
}
