output "instance_id" {
  description = "ID of the OpenVPN EC2 instance"
  value       = module.openvpn_server.instance_id
}

output "public_ip" {
  description = "Public IP address of the OpenVPN EC2 instance"
  value       = module.openvpn_server.public_ip
}