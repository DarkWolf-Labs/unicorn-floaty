output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.subnets.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.subnets.private_subnet_ids
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.internet_gateway.id
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.nat_gateway.nat_gateway_ids
}