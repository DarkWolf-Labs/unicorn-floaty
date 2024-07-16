# GCP Instructions

## Prereqs

1. This code is intended to be run using `terraform` but may also be compatible with `tofu`. The team is not testing against `tofu` at this time. [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
1. Running portions of this code locally may require `gcloud`  [Install gcloud](https://cloud.google.com/sdk/docs/install)

## Authenticating

It is recommended that you run both `gcloud auth login` and `gcloud application default login` to make sure that your ephemeral credentials are up to date before running any of the blueprints

## Blueprint Descriptions

### TAK Server

#### Description

This module deploys a new, non-public VPC, with a containerized TAK server deployed to it. For more information, see the README in the blueprint folder
