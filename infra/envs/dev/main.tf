module "infra" {
    source = "../.."
    project = "lp-hw-sep22"
    region = "us-south1"
    secret_name = "SA_KEY"
    cluster_name = "autopilot-hw"
    zone = "us-south1-a"
}