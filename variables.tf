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

variable "vault_name" {
  type        = string
  description = "The name of the key vault to be created. The value will be randomly generated if blank."
  default     = ""
}

variable "key_name" {
  type        = string
  description = "The name of the key to be created. The value will be randomly generated if blank."
  default     = ""
}

variable "sku_name" {
  type        = string
  description = "The SKU of the vault to be created."
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "The sku_name must be one of the following: standard, premium."
  }
}

variable "key_permissions" {
  type        = list(string)
  description = "List of key permissions."
  default     = ["List", "Create", "Delete", "Get", "Purge", "Recover", "Update", "GetRotationPolicy", "SetRotationPolicy"]
}

variable "secret_permissions" {
  type        = list(string)
  description = "List of secret permissions."
  default     = ["Set", "Delete", "Get", "List", "Purge", "Recover"]
}

variable "certificate_permissions" {
  type        = list(string)
  description = "List of certificate permissions."
  default     = ["Get", "List", "Delete", "Create", "Import", "Update", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers"]
}

variable "key_type" {
  description = "The JsonWebKeyType of the key to be created."
  default     = "RSA"
  type        = string
  validation {
    condition     = contains(["EC", "EC-HSM", "RSA", "RSA-HSM"], var.key_type)
    error_message = "The key_type must be one of the following: EC, EC-HSM, RSA, RSA-HSM."
  }
}

variable "key_ops" {
  type        = list(string)
  description = "The permitted JSON web key operations of the key to be created."
  default     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
}

variable "key_size" {
  type        = number
  description = "The size in bits of the key to be created."
  default     = 2048
}
