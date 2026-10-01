# 4. Custom Policy Definition: Restrict allowed Azure Locations
resource "azurerm_policy_definition" "allowed_locations" {
	name			= "allowed-azure-locations"
	policy_type		= "Custom"
	mode			= "All"
	management_group_id	= azurerm_management_group.org_root.id
	display_name		= "Allowed Azure Location"
	description		= "This policy restricts deployment of resources to specified allowed Azure regions"

	metadata = jsonencode ({
		category = "Governance"
	})

	policy_rule = jsonencode ({
		if = {
			not = {
				field 	= "location"
				in	= "[parameters('allowedLocations')]"
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

# 6. Custom Policy Definition: Require a specific tag on resources
resource "azurerm_policy_definition" "require_tag" {
	name			= "require-mandatory-tag"
	policy_type		= "Custom"
	mode			= "Indexed"
	display_name		= "Require Mandatory Tag"
	description		= "Ensures that all indexed resources have the specified"
	management_group_id	= azurerm_management_group.org_root.id

	metadata = jsonencode ({
		category = "Tags"
	})

	policy_rule = jsonencode ({
		if = {
			field = "[concat('tags[', parameters('tagName'), ']')]"
			exists = "false"
		}
		then = {
			effect = "deny"
		}
	})

	parameters = jsonencode ({
		tagName = {
			type 	 = "String"
			metadata = {
				displayName = "Mandatory Tag Name"
				description = "Name of the tag that must be present on resources."
			}
			defaultValue = "Enviroment"
		}
	})
}
