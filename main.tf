resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name_prefix}-rg01"
  location = var.resource_group_location
  tags     = var.tags
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

