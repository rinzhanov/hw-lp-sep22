variable "project" {
  type        = string
  description = "Project ID"
}

variable "region" {
  type        = string
  description = "Deployment region"
  default = "us-east4"
}

variable "secret_name" {
  type        = string
  description = "Secret with SA key for service account"
}

variable "cluster_name" {
  type        = string
  description = "Cluster Name"
 }

 variable "zone" {
     type = string
     description = "Zone for VM"
 }