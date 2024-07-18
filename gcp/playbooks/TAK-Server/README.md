# TAK Server on GCP

## Description

This containerized deployment is based off of the deployment instructions found on https://tak.gov/ and https://github.com/Cloud-RF/tak-server

## Capabilities

This blueprint deploys a TAK server with the following configuration

* Instances running the latest Rocky Linux
* A highly-available CloudSQL instance (w/o PostGIS extension enabled, instructions here https://cloud.google.com/sql/docs/postgres/extensions)
* Pull through proxy Artifact Registry to get access to Registry1 for hardened containers
* The latest TAK server deployed using hardened container from Registry1

## Getting TAK Server

To complete this deployment, you will have to get TAK Server from Iron Bank. This project configures Iron Bank as an Artifact Registry pull-through, but you will need Iron Bank credentials to get started.

 *TODO*: Typically we handle this in a bootstrap project somewhere else, because right now this will fail the first time through because the project doesn't exist yet. For now, you will have to run the `terraform apply --target module.project`, then you create the secret, then you rerun `terraform apply`.

Once you have your credentials ready, use the following command to add them to your gcloud project as a secret
```
echo -n "my super secret data" | gcloud secrets create registry-secret \
    --project=<prefix>-<project_id>
    --replication-policy="automatic" \
    --data-file=-
```

## Variables

| Name | Description | Default | Type | Validation |
|---|---|---|---|---|
| region | GCP Region to deploy into | us-east4 | string | N/A |
| prefix | Prefix used for resource names. | N/A | string | Cannot be empty |
| project_create | Provide values if project creation is needed | null | object | N/A |
| project_id | Project id references existing project if project_create is null. | N/A | string | N/A |
| vpc_config | Shared VPC network configurations to use | null | object | N/A |
| service_encryption_keys | Cloud KMS to use to encrypt different services | null | object | N/A |
| sql_configuration.sql_availability_type | Cloud SQL availability type | ZONAL | string | N/A |
| sql_configuration.sql_database_version | Cloud SQL database version | POSTGRES_13 | string | N/A |
| sql_configuration.sql_psa_range | Cloud SQL PSA range | 10.60.0.0/16 | string | N/A |
| sql_configuration.sql_tier | Cloud SQL tier | db-g1-small | string | N/A |
| postgres_database | postgres database | tak | string | N/A |
| postgres_user_password | postgres user password | N/A | string | N/A |

## Outputs

| name | description | sensitive |
|---|---|:---:|
| tak-server | Internal IP of the TAK server, suitable for accessing via an OpenVPN instance inside the VPC |  false |
