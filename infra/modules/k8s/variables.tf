variable "cluster_name" {
  description = "Cluster name"
  type        = string

}

variable "cluster_region" {
  description = "Cluster region"
  type        = string
}

variable "project" {
  description = "Project for cluster"
  type        = string
}

variable "network" {
  description = "VPC for cluster"
  type        = string
}

variable "subnetwork" {
  description = "Subnet for cluster"
  type        = string
}

variable "cluster_gke_master_ipv4_cidr_block" {
  description = "cidr block to be used by gke for the cluster master network"
  type        = string
}

variable "env_vars_k8s" {
  description = "Environment variables to deploy app on gke via shell script"
}
  