# 7. Policy Initiative: Baseline Governance
resource "azurerm_policy_set_defition" "baseline_governance" {
	name			= "org-baseline=governance"
	policy_type		= "Custom"
	display_name		= "Orgamizational Baseline Governance"
	description		= "Initiative containing fundamental governance policies for the organization"
	management_group_id	= azurerm_management_group.org_root.id

	parameters = jsoncode ({
		allowedLocations = {
			type 	 = "Array"
			metadata = {
				displayName = "Allowed Locations"
			}
			defaultValue = ["eastus", "eastus"]
		}
		requiredTagName = {
			type 	 = "String"
			metadata = {
				displayName = "Required Tag Name"
			}
			defaultValue = "Environment"
		}
	})

	policy_definition_reference {
		policy_definition_id	= azurerm_policy_definition.allowed_locations.id
		reference_id		= "restrictLocations"
		parameter_values = jsonencode ({
			allowedLocations = { value = "[parameters('allowedLocations')]" }
		})
	}

	policy_definition_reference {
		policy_definition_id	= azurerm_policy_definition.require_tag.id
		reference_id		= "requireEnvironmentTag"
		parameter_values = jsonencode ({
			tagName = { value= "[parameters('requiredTagName')]" }
		})
	}
}
