#output "subnet" {
#  value = azurerm_subnet.internal
#}

output "ip" {
  value = azurerm_public_ip.myip.ip_address
}