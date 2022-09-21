variable "project" {
  type        = string
  description = "project"
}

variable "instance-group" {
  type        = string
  description = "self-link of instance group"
}

variable "network" {
  description = "network for NAT/vm"
}
variable "vm_tag" {
  type        = string
  description = "network tag for load balanced VMs"
}
 