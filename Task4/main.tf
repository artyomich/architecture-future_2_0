terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Основная Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    Environment = var.environment
    Project     = "Future 2.0"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-vnet"
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Подсети
resource "azurerm_subnet" "medical" {
  name                 = "${var.prefix}-subnet-medical"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_medical_address]
}

resource "azurerm_subnet" "fintech" {
  name                 = "${var.prefix}-subnet-fintech"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_fintech_address]
}

resource "azurerm_subnet" "ai" {
  name                 = "${var.prefix}-subnet-ai"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_ai_address]
}

resource "azurerm_subnet" "analytics" {
  name                 = "${var.prefix}-subnet-analytics"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_analytics_address]
}

resource "azurerm_subnet" "integration" {
  name                 = "${var.prefix}-subnet-integration"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_integration_address]
}

# NAT Gateway (только для Integration)
resource "azurerm_public_ip" "nat" {
  name                = "${var.prefix}-nat-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "main" {
  name                    = "${var.prefix}-nat-gateway"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10

  resource_guid = "00000000-0000-0000-0000-000000000000"
}

resource "azurerm_subnet_nat_gateway_association" "integration" {
  subnet_id      = azurerm_subnet.integration.id
  nat_gateway_id = azurerm_nat_gateway.main.id
}

# Network Security Groups
resource "azurerm_network_security_group" "medical" {
  name                = "${var.prefix}-nsg-medical"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
# ... (аналогично для fintech, ai, analytics, integration)

# Public IP для Load Balancer
resource "azurerm_public_ip" "lb" {
  name                = "${var.prefix}-lb-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Load Balancer
resource "azurerm_lb" "main" {
  name                = "${var.prefix}-lb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}

# NIC и VM
resource "azurerm_network_interface" "medical" {
  name                = "${var.prefix}-nic-medical"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.medical.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "medical" {
  name                            = "${var.prefix}-vm-medical"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = var.vm_medical_size
  admin_username                  = var.admin_username
  network_interface_ids           = [azurerm_network_interface.medical.id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = azurerm_resource_group.main.tags
}
# ... (аналогично для fintech, ai, etl, portal, gateway, eventbus)

# Managed Disks
resource "azurerm_managed_disk" "medical" {
  name                 = "${var.prefix}-disk-medical"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  storage_account_type = var.disk_type
  create_option        = "Empty"
  disk_size_gb         = var.disk_medical_size
}
# ... (аналогично для fintech, ai, data_warehouse)

# Подключение дисков
resource "azurerm_virtual_machine_data_disk_attachment" "medical" {
  managed_disk_id    = azurerm_managed_disk.medical.id
  virtual_machine_id = azurerm_linux_virtual_machine.medical.id
  lun                = "0"
  caching            = "ReadWrite"
}
# ... (аналогично для других VM)