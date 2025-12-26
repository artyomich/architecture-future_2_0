# Основные настройки
variable "resource_group_name" {
  description = "Имя Resource Group"
  type        = string
  default     = "rg-future-2-0"
}

variable "location" {
  description = "Регион Azure"
  type        = string
  default     = "West Europe"
}

variable "prefix" {
  description = "Префикс для именования ресурсов"
  type        = string
  default     = "future20"
}

variable "environment" {
  description = "Окружение (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# Сеть
variable "vnet_address_space" {
  type    = string
  default = "10.0.0.0/16"
}
# ... (аналогично для всех subnet_*_address)

# ВМ
variable "vm_medical_size" { type = string; default = "Standard_B2s" }
variable "vm_fintech_size" { type = string; default = "Standard_B2s" }
variable "vm_ai_size" { type = string; default = "Standard_D2s_v3" }
variable "vm_etl_size" { type = string; default = "Standard_D4s_v3" }
variable "vm_portal_size" { type = string; default = "Standard_B2s" }
variable "vm_gateway_size" { type = string; default = "Standard_B2s" }
variable "vm_eventbus_size" { type = string; default = "Standard_D2s_v3" }

# Диски
variable "disk_type" { type = string; default = "Premium_LRS" }
variable "disk_medical_size" { type = number; default = 100 }
variable "disk_fintech_size" { type = number; default = 100 }
variable "disk_ai_size" { type = number; default = 200 }
variable "disk_dw_size" { type = number; default = 500 }

# Безопасность
variable "admin_username" { type = string; default = "azureuser" }
variable "ssh_public_key" { type = string; sensitive = true }