output "resource_group_name" {
  description = "Имя Resource Group"
  value       = azurerm_resource_group.main.name
}

output "load_balancer_public_ip" {
  description = "Публичный IP-адрес Load Balancer"
  value       = azurerm_public_ip.lb.ip_address
}

output "vm_medical_private_ip" {
  description = "Приватный IP-адрес Medical VM"
  value       = azurerm_network_interface.medical.private_ip_address
}
# ... (аналогично для других ключевых выходных параметров)