variable "region" {
  description = "GCP Region to deploy into"
  type = string
  default = "us-east4"
}

variable "prefix" {
  description = "Prefix used for resource names."
  type        = string
  validation {
    condition     = var.prefix != ""
    error_message = "Prefix cannot be empty."
  }
}

variable "project_create" {
  description = "Provide values if project creation is needed, use existing project if null. Parent format:  folders/folder_id or organizations/org_id."
  type = object({
    billing_account_id = string
    parent             = string
  })
  default = null
}

variable "project_id" {
  description = "Project id references existing project if `project_create` is null."
  type        = string
}

variable "service_encryption_keys" {
  description = "Cloud KMS to use to encrypt different services. The key location should match the service region."
  type = object({
    aiplatform = optional(string, null)
    bq         = optional(string, null)
    compute    = optional(string, null)
    storage    = optional(string, null)
  })
  default = null
}

variable "vpc_config" {
  description = "Shared VPC network configurations to use. If null networks will be created in projects with pre-configured values."
  type = object({
    host_project      = string
    network_self_link = string
    subnet_self_link  = string
  })
  default = null
}