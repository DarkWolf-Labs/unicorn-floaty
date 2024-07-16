# Google Cloud native container run

locals {
  registry-one = "${var.region}-docker.pkg.dev/${module.project.id}/${google_artifact_registry_repository.registry-one-repo.name}"
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
    subnetwork = "projects/${module.project.id}/regions/${var.region}/subnetworks/subnet-${module.project.number}"
  }]
  # Persistent Disk Attached to the Compute Engine with KMS
  attached_disks = [
    {
      auto_delete = "true"
      size        = 20
      name        = "data-disk"
      initialize_params = {
        image = "projects/cos-cloud/global/images/family/cos-stable"
      }
    }
  ]
  metadata = {
    user-data = module.cos-tak.cloud_config
  }
}