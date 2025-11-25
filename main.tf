resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name_prefix}-rg01-${random_integer.rg_suffix.result}"
  location = var.resource_group_location
  tags     = var.tags
}

resource "random_integer" "rg_suffix" {
  min = 2
  max = 3
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}
output "resource_group_location" {
  value = azurerm_resource_group.rg.location
}
output "resource_group_tags" {
  value = azurerm_resource_group.rg.tags
}
output "resource_group_subscription_id" {
  value = azurerm_resource_group.rg.subscription_id
}
