output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "ubuntu_server_public_ip" {
  description = "Public IP of the Ubuntu server"
  value       = module.ubuntu_server.public_ip
}

output "traccar_server_public_ip" {
  description = "Public IP of the Traccar server"
  value       = module.traccar_server.public_ip
}

output "openvpn_server_public_ip" {
  description = "Public IP of the OpenVPN server"
  value       = module.openvpn_server.public_ip
}

output "matrix_server_public_ip" {
  description = "Public IP of the Matrix server"
  value       = module.matrix_server.public_ip
}
# output "nat_gateway_ids" {
#   description = "List of NAT Gateway IDs"
#   value       = module.vpc.nat_gateway_ids
# }