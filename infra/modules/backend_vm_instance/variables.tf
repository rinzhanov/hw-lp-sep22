variable "machine_type" {
  description = "Machine type"
  default     = "e2-standard-2"
}

variable "zone" {
  description = "Zone"
}

variable "subnetwork" {
  description = "subnet for vm"
}

variable "project" {
  description = "Project for VM"
  type        = string
}

variable "network" {
  description = "network for NAT/vm"
}

variable "region" {
  description = "region for NAT"
}

variable "vm_tag" {
  type        = string
  description = "network tag for load balanced VMs"
}