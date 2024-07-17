# Google Cloud native container run

locals {
  registry-one = "${var.region}-docker.pkg.dev/${module.project.id}/${google_artifact_registry_repository.registry-one-repo.name}"
}

module "tak-service-account" {
  name       = "tak-compute"
  source     = "../../modules/iam-service-account"
  project_id = module.project.project_id
  iam_project_roles = {
    "${module.project.project_id}" = [
      "roles/artifactregistry.reader"
    ]
  }
}

module "cos-tak" {
  source          = "../..//modules/cloud-config-container/cos-generic-metadata"
  container_image = "${local.registry-one}/${var.registry_one_image_path}:${var.registry_one_image_version}"
  container_name  = "tak-server"
  container_args  = "sleep"
}

# Google Compute Engine VM Module
module "compute-engine-vm" {
  source        = "../../modules/compute-vm"
  project_id    = module.project.id
  zone          = "${var.region}-b" # I think all the regions have a "b", but not an "a"
  name          = "${var.prefix}-tak-server"
  instance_type = var.instance_type
  network_interfaces = [{
    network    = module.vpc[0].network.self_link
    subnetwork = module.vpc[0].subnet_ids["${var.region}/${var.prefix}-subnet"]
  }]
  tags = ["iap-ssh"]
  shielded_config = {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
  boot_disk = {
    auto_delete = true
    size        = 30
    initialize_params = {
      image = "projects/rocky-linux-cloud/global/images/rocky-linux-9-optimized-gcp"
    }
  }

  metadata = {
    user-data = module.cos-tak.cloud_config
  }
  service_account = {
    email = module.tak-service-account.email
  }
}

