
module "db" {
  source     = "../../modules/cloudsql-instance"
  project_id = module.project.project_id
  network_config = {
    connectivity = {
    #   psa_config = {
    #     private_network = module.vpc[0].self_link
    #   }
      psc_allowed_consumer_projects = [module.project.project_id,]
    }
  }
  name                          = "db"
  region                        = var.region
  database_version              = "POSTGRES_15"
  tier                          = "db-g1-small"
  gcp_deletion_protection       = false
  terraform_deletion_protection = false
}