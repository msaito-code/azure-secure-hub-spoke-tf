# 6. Custom Policy Definition: Require a specific tag on resources
resource "azurerm_policy_definition" "require_tag" {
	name			= "require-mandatory-tag"
	policy_type		= "Custom"
	mode			= "Indexed"
	display_name		= "Require Mandatory Tag"
	description		= "Ensures that all indexed resources have the specified"
	management_group_id	= azurerm_management_group_org_root.id

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
