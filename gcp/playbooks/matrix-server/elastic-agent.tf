resource "google_secret_manager_secret" "agent-config" {
  secret_id = "agent-config"
  project   = module.project.id

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_iam_binding" "agent-config-secret-binding" {
  project   = module.project.id
  secret_id = google_secret_manager_secret.agent-config.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    module.matrix-service-account.service_account.member,
    module.openvpn-service-account.service_account.member
  ]
}

# Store this as a secret because it has the db-password in it
resource "google_secret_manager_secret_version" "agent-config-version" {
  secret = google_secret_manager_secret.agent-config.id
  secret_data = templatefile("./templates/elastic-agent.yml", {
    region = var.region,
  })
}
