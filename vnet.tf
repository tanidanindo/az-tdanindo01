
resource "azurerm_network_security_group" "nsg01" {
  name                = "nsg-allow-rdp-from-specific-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow_rdp_specific_ips" {
  # Association with the NSG
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg01.name

  name                   = "Allow_RDP_Specific"
  priority               = 100
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "Tcp"
  source_port_range      = "*"
  destination_port_range = "3389" # RDP Port

  # Allows traffic from both specified IPs using a comma-separated list
  source_address_prefixes    = ["165.225.210.0/24", "184.65.164.83/32", "198.14.68.114/32"]
  destination_address_prefix = "4.155.96.63/32"
}

# --- 4. Rule for HTTP and HTTPS Access (All Addresses) ---
resource "azurerm_network_security_rule" "allow_web_traffic" {
  # Association with the NSG
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg01.name

  name              = "Allow_HTTP_HTTPS_All"
  priority          = 110 # Priority 110 is lower than 100, evaluated second
  direction         = "Inbound"
  access            = "Allow"
  protocol          = "Tcp"
  source_port_range = "*"

  # Allows traffic on both ports 80 (HTTP) and 443 (HTTPS)
  destination_port_ranges = ["80", "443"]

  # Allows traffic from any source
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "tani-vnet01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  # The ID of the newly created subnet
  subnet_id = azurerm_subnet.subnet.id

  # The ID of the existing NSG retrieved via the data block
  network_security_group_id = azurerm_network_security_group.nsg01.id
}
