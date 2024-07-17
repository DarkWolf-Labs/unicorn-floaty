output "key_name" {
  description = "The name of the created key pair"
  value       = module.keypair.key_name
}

output "private_key_path" {
  description = "The path to the private key file"
  value       = module.keypair.private_key_path
}

# You can add other EC2-related outputs here in the future