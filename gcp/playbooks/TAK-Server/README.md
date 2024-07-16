# TAK Server on GCP

## Description

This deployment is based off of the deployment instructions found on https://tak.gov/

## Capabilities

This blueprint deploys a TAK server with the following configuration

* Managed Instance Group (MIG) providing high-availability
* Instances running the latest Rocky Linux
* The latest TAK server deployed to OpenJDK
* A highly-available CloudSQL instance with PostGIS extension enabled
* An Internal Load Balancer for access (ILB will forward TCP and UDP to host)
