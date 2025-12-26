resource_group_name = "rg-future-2-0"
location = "West Europe"
prefix = "future20"
environment = "dev"

# Сетевые настройки
vnet_address_space = "10.0.0.0/16"
subnet_medical_address = "10.0.1.0/24"
subnet_fintech_address = "10.0.2.0/24"
subnet_ai_address = "10.0.3.0/24"
subnet_analytics_address = "10.0.4.0/24"
subnet_integration_address = "10.0.5.0/24"

# Аутентификация (ЗАМЕНИТЕ НА СВОЙ КЛЮЧ!)
ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIYOUR_REAL_PUBLIC_KEY_HERE"