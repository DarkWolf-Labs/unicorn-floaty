# GCP Instructions

## Prereqs

1. This code is intended to be run using `terraform` but may also be compatible with `tofu`. The team is not testing against `tofu` at this time. [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
1. Running portions of this code locally may require `gcloud`  [Install gcloud](https://cloud.google.com/sdk/docs/install)

## Authenticating

It is recommended that you run both `gcloud auth login`, `gcloud auth application-default login`, and `gcloud config set project <project>` to make sure that your ephemeral credentials are up to date before running any of the blueprints

## Playbook Descriptions

### TAK Server

#### Description

This module deploys a new, non-public VPC, with a containerized TAK server deployed to it. For more information, see the README in the blueprint folder


## Modules descriptions

These modules are composable and meant to used in the blueprints/ that are predefined, as well as new blueprints created by customers.

Some of the baseline modules were taken from the [Cloud Foundation Fabric](https://github.com/GoogleCloudPlatform/cloud-foundation-fabric/tree/master/modules), a codebase officially maintained by Google and one that Dark Wolf actively maintains a branch of for DoD specific deployments. Dark Wolf is currently working with the CFF team to upstream our improvements for deploying applications into Assured Workloads environments such as IL4 and IL5.