
locals {
  service_encryption_keys = var.service_encryption_keys
  shared_vpc_project      = try(var.vpc_config.host_project, null)
  subnet = (
    local.use_shared_vpc
    ? var.vpc_config.subnet_self_link
    : values(module.vpc[0].subnet_self_links)[0]
  )
  use_shared_vpc = var.vpc_config != null
  vpc = (
    local.use_shared_vpc
    ? var.vpc_config.network_self_link
    : module.vpc[0].self_link
  )
}

module "project" {
  source          = "../../modules/project"
  name            = var.project_id
  parent          = try(var.project_create.parent, null)
  billing_account = try(var.project_create.billing_account_id, null)
  project_create  = var.project_create != null
  prefix          = var.project_create == null ? null : var.prefix
  services = [
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "storage.googleapis.com",
    "storage-component.googleapis.com"
  ]
  service_encryption_key_ids = {
    aiplatform = [try(local.service_encryption_keys.compute, null)]
    compute    = [try(local.service_encryption_keys.compute, null)]
    bq         = [try(local.service_encryption_keys.bq, null)]
    storage    = [try(local.service_encryption_keys.storage, null)]
  }
  service_config = {
    disable_on_destroy = false, disable_dependent_services = false
  }
}