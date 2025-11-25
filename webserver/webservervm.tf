
data "azurerm_key_vault_secret" "vm_admin_password" {
  name         = "vmadminpassword" # Replace with your secret name
  key_vault_id = resource.azurerm_key_vault.vault.id
}
# --- 1. Public IP Address ---
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "windows-vm-public-ip"
  resource_group_name = resource.azurerm_resource_group.rg.name
  location            = resource.azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# --- 2. Network Interface (NIC) ---
resource "azurerm_network_interface" "vm_nic" {
  name                = "windows-vm-nic"
  resource_group_name = resource.azurerm_resource_group.rg.name
  location            = resource.azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = resource.azurerm_subnet.subnet.id # Connects to EXISTING VNet/Subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id # Associates the Public IP
  }
} # --- 3. Boot Diagnostics Storage Account ---
# This is required for enabling boot diagnostics, which is highly recommended.
resource "azurerm_storage_account" "bootdiag_sa" {
  name                     = "vmdiags${lower(replace(resource.azurerm_resource_group.rg.name, "-", ""))}" # Unique name required
  resource_group_name      = resource.azurerm_resource_group.rg.name
  location                 = resource.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# --- 4. Virtual Machine ---
# --- 4. Virtual Machine ---
resource "azurerm_windows_virtual_machine" "main" {
  name                = "webserver01"
  resource_group_name = resource.azurerm_resource_group.rg.name
  location            = resource.azurerm_resource_group.rg.location
  size                = "Standard_B2s"
  admin_username      = "taniadmin"
  admin_password      = data.azurerm_key_vault_secret.vm_admin_password.value # <--- IMPORTANT: Change this to a secure, generated password

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  # Configuration to run Windows Server 2022
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter" # Specifies Windows Server 2022
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Enable Boot Diagnostics
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.bootdiag_sa.primary_blob_endpoint
  }
}
