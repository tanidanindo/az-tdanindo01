variable "resource_group_location" {
  type        = string
  default     = "west us 2"
  description = "Location of the resource group."
}

variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
  default     = "West US 2"
}
variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}
variable "tags" {
  type = map(string)
  default = {
    environment = "dev"
    project     = "tdanindo01"
  }
  description = "A map of tags to assign to the resources."
}
variable "tenant_id" {
  type        = string
  description = "The tenant ID of the Azure Active Directory. If this value isn't null (the default), 'data.azurerm_client_config.current.tenant_id' will be set to this value."
  default     = null
}

variable "object_id" {
  type        = string
  description = "The object ID of the Azure Active Directory. If this value isn't null (the default), 'data.azurerm_client_config.current.object_id' will be set to this value."
  default     = null
}
variable "subscription_id" {
  type        = string
  description = "The subscription ID of the Azure Active Directory. If this value isn't null (the default), 'data.azurerm_client_config.current.subscription_id' will be set to this value."
  default     = null
}
