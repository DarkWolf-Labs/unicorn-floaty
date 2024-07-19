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

resource "google_secret_manager_secret" "core-config" {
  secret_id = "core-config"
  project   = module.project.id

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_iam_binding" "core-config-secret-binding" {
  project   = module.project.id
  secret_id = google_secret_manager_secret.core-config.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    module.tak-service-account.service_account.member,
  ]
}

# Store this as a secret because it has the db-password in it
resource "google_secret_manager_secret_version" "core-config-version" {
  secret = google_secret_manager_secret.core-config.id
  secret_data = templatefile("./templates/CoreConfig.xml.tftpl", {
    db_user     = "cot",
    db_password = random_password.db-password.result,
    db_host     = module.db.dns_name,
  })
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
  tags = [
    "iap-ssh",
    "tak-server"
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
    startup-script = templatefile("./templates/userdata.tftpl", {
      region      = var.region
      image_path  = "${local.registry-one}/${var.registry_one_image_path}:${var.registry_one_image_version}",
      core_config = google_secret_manager_secret.core-config.secret_id,
      agent_init  = templatefile("./templates/agent-init.tftpl", {})

    })
  }

  service_account = {
    email = module.tak-service-account.email
  }
}

