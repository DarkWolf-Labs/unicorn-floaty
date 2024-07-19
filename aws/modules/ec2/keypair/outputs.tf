output "key_name" {
  description = "The name of the created key pair"
  value       = aws_key_pair.this.key_name
}

output "private_key_path" {
  description = "The path to the private key file"
  value       = var.private_key_path
}

output "public_key" {
  description = "The public key of the created key pair"
  value       = tls_private_key.this.public_key_openssh
}