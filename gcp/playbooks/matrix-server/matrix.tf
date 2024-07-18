# Google Cloud native container run

locals {
  registry-one = "${var.region}-docker.pkg.dev/${module.project.id}/${google_artifact_registry_repository.registry-one-repo.name}"
}

module "matrix-service-account" {
  name       = "matrix-compute"
  source     = "../../modules/iam-service-account"
  project_id = module.project.project_id
  iam_project_roles = {
    "${module.project.project_id}" = [
      "roles/artifactregistry.reader"
    ]
  }
}

# Google Compute Engine VM Module
module "compute-engine-vm" {
  source        = "../../modules/compute-vm"
  project_id    = module.project.id
  zone          = "${var.region}-b" # I think all the regions have a "b", but not an "a"
  name          = "${var.prefix}-matrix-server"
  instance_type = var.instance_type
  network_interfaces = [{
    network    = module.vpc[0].network.self_link
    subnetwork = module.vpc[0].subnet_ids["${var.region}/${var.prefix}-subnet"]
  }]
  tags = [
    "iap-ssh",
    "matrix-server"
  ]
  shielded_config = {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
  boot_disk = {
    auto_delete = true
    initialize_params = {
      size = 30

      image = "rocky-linux-cloud/rocky-linux-9-optimized-gcp"
    }
  }

  # Check the status of the startup script on the box with `sudo journalctl -u google-startup-scripts.service`
  metadata = {
    startup-script = templatefile("./templates/docker-compose.yml", {
      region      = var.region
      registryone  = local.registry-one,
      servername = var.server_name
    })
  }

  service_account = {
    email = module.matrix-service-account.email
  }
}

