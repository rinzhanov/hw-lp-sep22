# A solution of Terraform assignment by Rin Zhanov

## Overview

This is a solution of Terraform assignment. The task was to deploy a connectable service on GCP.

The repo contains the code that would automate such deployment in 3 ways:
1. A load balanced private compute instance with a simple Apache web server
2. A Cloud Run deployment of publicly available service
3. A GKE Autopilot cluster with exposes a pod with helloworld container via Ingress

Further details are provided in the documentation.

It is assumed that the project for deployment already exists on GCP. It is also assumed that there is a secret in this project with a JSON key from a service account that has at least container.admin role (in the future the secret should be made accessible to terraform via CI/CD pipeline secret).

## Code structure

The repo is organized in the following way. 

/infra/ is a folder containing: 
1. /envs/ folder with parameters for each of the environment (for now, only dev), 
2. /modules/ folder containing custom modules
3. main.tf and variable.tf files that accept variables from the corresponding file with parameters in /envs/dev/ and then deploy the actual infrastructure on GCP (with the help of modules)

## Key variables

Key parameteres are defined in main.tf file in /infra/env/dev/ folder. They include project id, region and zone for deployment, vm_tag for setting up tag based firewall rule for health checks, and GKE cluster name and a secret name which store a service account key needed to authorize on GKE cluster.

## Usage

To run, please go to /infra/envs/dev/ and do terraform init, terraform plan and terraform apply.
