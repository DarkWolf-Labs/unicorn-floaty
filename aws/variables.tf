variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, staging, prod)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ubuntu_ami_id" {
  description = "AMI ID for Ubuntu"
  type        = string
}

variable "debian_ami_id" {
  description = "AMI ID for Debian"
  type        = string
}

variable "matrix_domain" {
  description = "Domain name for the Matrix server"
  type        = string
  default     = "yourdomain.com"  # You can set a default value or leave it blank
}

variable "auto_start_matrix" {
  description = "Whether to automatically start Matrix services after setup"
  type        = bool
  default     = false
}