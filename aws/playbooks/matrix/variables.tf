variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, staging, prod)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the Debian instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}


variable "subnet_id" {
  description = "ID of the subnet to launch the instance in"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group"
  type        = string
}

variable "matrix_domain" {
  description = "Domain name for the Matrix server"
  type        = string
  default     = "domain.com"
}

variable "auto_start_matrix" {
  description = "Whether to automatically start Matrix services after setup"
  type        = bool
  default     = false
}