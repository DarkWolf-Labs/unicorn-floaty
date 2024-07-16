variable "region" {
  description = "GCP Region to deploy into"
  type        = string
  default     = "us-east4"
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

variable "vpc_config" {
  description = "Shared VPC network configurations to use. If null networks will be created in projects with pre-configured values."
  type = object({
    host_project      = string
    network_self_link = string
    subnet_self_link  = string
  })
  default = null
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

variable "sql_configuration" {
  description = "Cloud SQL configuration."
  type = object({
    availability_type = string
    database_version  = string
    psa_range         = string
    tier              = string
  })
  default = {
    availability_type = "ZONAL"
    database_version  = "POSTGRES_13"
    psa_range         = "10.60.0.0/16"
    tier              = "db-g1-small"
  }
}

variable "sql_users" {
  description = "Cloud SQL user emails."
  type        = list(string)
  default     = []
}

variable "postgres_database" {
  description = "`postgres` database."
  type        = string
  default     = "tak"
}

variable "postgres_user_password" {
  description = "`postgres` user password."
  type        = string
}

variable "registry_username" {
  description = "Username for Registry1 https://registry1.dso.mil/"
  type        = string
}

variable "registry_password_secret" {
  # DO NOT ENTER YOUR PASSWORD IN YOUR TFVARS, THE PASSWORD GOBLINS WILL HUNT YOU DOWN
  description = "The *name* of the secret that you created in the README"
  type        = string
}