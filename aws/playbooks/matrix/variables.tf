variable "instance_type" {
  description = "The instance type to use for the Matrix server"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for the instance"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to launch the instance in"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to create the security group in"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key file for SSH access"
  type        = string
}