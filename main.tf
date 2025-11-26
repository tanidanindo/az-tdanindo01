resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name_prefix}-rg01"
  location = var.resource_group_location
  tags     = var.tags
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

resource "azurerm_log_analytics_workspace" "tanilaw01" {
  # Configuration details
  name                = "tanilaw01" # Must be globally unique
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018" # Pricing Tier (e.g., Free, PerGB2018, Consumption, etc.)

  # Retention setting (data older than this is purged)
  retention_in_days = 30
}
