# tron/aws/modules/iam/variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, staging, prod)"
  type        = string
}

variable "service_name" {
  description = "Name of the service (e.g., tak, matrix)"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to grant access to"
  type        = string
}

variable "s3_actions" {
  description = "List of S3 actions to allow"
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]
}