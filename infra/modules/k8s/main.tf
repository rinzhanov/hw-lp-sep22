resource "google_container_cluster" "autopilot-hw" {

  name     = var.cluster_name
  location = var.cluster_region

  project = var.project

  network    = var.network
  subnetwork = var.subnetwork

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.cluster_gke_master_ipv4_cidr_block
  }

  # Enable Autopilot for this cluster
  enable_autopilot = true

  # Configuration of cluster IP allocation for VPC-native clusters
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
}

resource "null_resource" "deploy-app" {
  triggers = {
    run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command     = "/bin/bash ${path.module}/deploy-app.sh"
    environment = var.env_vars_k8s
  }
  depends_on = [
    google_container_cluster.autopilot-hw
  ]
}
