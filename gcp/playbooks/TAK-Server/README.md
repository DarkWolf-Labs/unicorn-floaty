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

 *TODO*: Typically we handle this in a bootstrap project somewhere else, because right now this will fail the first time through because the project doesn't exist yet. For now, you will have to run the `terraform apply` and it will fail out, then you create the secret, then you rerun `terraform apply`.

Once you have your credentials ready, use the following command to add them to your gcloud project as a secret
```
echo -n "my super secret data" | gcloud secrets create registry-secret \
    --project=<prefix>-<project_id>
    --replication-policy="automatic" \
    --data-file=-
```

