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

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

# output "matrix_server_public_ip" {
#   description = "The public IP address of the Matrix chat server"
#   value       = module.matrix_server.matrix_server_public_ip
# }

# output "matrix_server_instance_id" {
#   description = "The instance ID of the Matrix chat server"
#   value       = module.matrix_server.matrix_server_instance_id
# }

# output "nat_gateway_ids" {
#   description = "List of NAT Gateway IDs"
#   value       = module.vpc.nat_gateway_ids
# }