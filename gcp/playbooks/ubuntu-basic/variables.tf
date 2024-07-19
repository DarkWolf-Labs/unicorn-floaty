variable "region" {
  description = "GCP Region to deploy into"
  type        = string
  default     = "us-east4"

  validation {
    error_message = "Must be a valid GCP region"
    condition     = contains(["us-central1", "us-central2", "us-east1", "us-east2", "us-east4", "us-south1", "us-west1", "us-west3", "us-west4"], var.region)
  }
}
variable "prefix" {
  description = "Prefix used for resource names."
  type        = string

  validation {
    error_message = "Prefix must have between 2 and 5 alphanumeric characters."
    condition     = length(var.prefix) >= 2 && length(var.prefix) <= 5
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

variable "registry_username" {
  description = "Username for Registry1 https://registry1.dso.mil/"
  type        = string
}

variable "registry_password_secret" {
  # DO NOT ENTER YOUR PASSWORD IN YOUR TFVARS, THE PASSWORD GOBLINS WILL HUNT YOU DOWN
  description = "The *name* of the secret that you created in the README"
  type        = string
}

variable "instance_type" {
  description = "Instance type for TAK server"
  default     = "n2-standard-2"

  validation {
    # Use a set of valid instance types here instead of relying on a non-existent function.
    condition = contains([
      "n2-standard-2",
      "n2-standard-4",
      "n2-standard-8",
      "n2-standard-16",
      "n2-standard-32",
      "n4-standard-4",
      "n4-standard-8",
      "n4-standard-16",
      "n4-standard-32",
      "n2d-standard-4",
      "n2d-standard-8",
      "n2d-standard-16",
      "n2d-standard-32",
      "c4-standard-4",
      "c4-standard-8",
      "c4-standard-16",
      "c4-standard-32",
    ], var.instance_type)
    error_message = "Invalid GCP instance class: ${var.instance_type}"
  }
}
