# 1. The Root Management Group (for company-wide policies)
resource "azurerm_management_group" "org_root" {
	display_name	= "Portfolio-Org-Root"
	name		= "portfolio-org-root"
}

# 2. Production Management Group
resource "azurerm_management_group" "prod_mg" {
	display_name			= "Production"
	name				= "portfolio-prod"
	parent_management_group_id	= azurerm_management_group.org_root.id
}

# 3. Development Management Group
resource "azurerm_management_group" "dev_mg" {
	display_name			= "Development"
	name				= "portfolio-dev"
	parent_management_group_id	= azurerm_management_group.org_root.id
}
