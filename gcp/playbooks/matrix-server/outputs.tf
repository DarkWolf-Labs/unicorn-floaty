output "server_ip" {
  description = "IP address of the Matrix server deployment"
  value       = module.compute-engine-vm.internal_ip
}

output "openvpn_ip" {
  description = "Public IP of the OpenVPN server"
  value       = module.openvpn-vm.external_ip
}