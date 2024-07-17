output "key_name" {
  description = "The name of the created key pair"
  value       = aws_key_pair.this.key_name
}

output "private_key_path" {
  description = "The path to the private key file"
  value       = local_file.private_key.filename
}