# Configure pull through registry for Registry1 (Iron Bank) so we can use their hardened TAK Server container

resource "google_artifact_registry_repository" "registry-one-repo" {
  location = var.region
  project  = module.project.id

  repository_id = "registry1"
  description   = "Remote copy of registry1"
  format        = "DOCKER"
  mode          = "REMOTE_REPOSITORY"
  remote_repository_config {
    description = "Upstream repository for registry1"
    docker_repository {
      custom_repository {
        uri = "https://registry1.dso.mil"
      }
    }
    upstream_credentials {
      username_password_credentials {
        username                = var.registry_username
        password_secret_version = data.google_secret_manager_secret_version.registry-one-password.name
      }
    }
  }
}
data "google_secret_manager_secret" "registry-one-password-secret" {
  secret_id = var.registry_password_secret
  project   = module.project.id
}
data "google_secret_manager_secret_version" "registry-one-password" {
  secret  = var.registry_password_secret
  project = module.project.id
}

resource "google_secret_manager_secret_iam_member" "secret-access" {
  project = module.project.id

  secret_id = data.google_secret_manager_secret.registry-one-password-secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:service-${module.project.number}@gcp-sa-artifactregistry.iam.gserviceaccount.com"
}

# Set up a local yum repo
resource "google_artifact_registry_repository" "rocky-9" {
  location      = var.region
  repository_id = "rocky-9"
  project       = module.project.id

  format = "YUM"
  mode   = "REMOTE_REPOSITORY"
  remote_repository_config {
    description = "Rocky 9 remote repository"
    yum_repository {
      public_repository {
        repository_base = "ROCKY"
        repository_path = "pub/rocky/9/BaseOS/x86_64/os"
      }
    }
  }
}