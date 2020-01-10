module "vpc" {
  source  = "terraform-google-modules/network/google"

  project_id   = var.project
  routing_mode = "REGIONAL"

  routes = var.routes
  subnets = var.subnets

  network_name = "${var.prefix}-network"
}
