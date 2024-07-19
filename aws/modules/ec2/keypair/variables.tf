variable "key_name" {
  description = "The name for the key pair"
  type        = string
}

variable "private_key_path" {
  description = "The path where the private key will be stored locally"
  type        = string
}

# You can add other EC2-related variables here in the future