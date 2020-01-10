terraform {
  backend "gcs" {}
}

provider "google" {
  project = var.project
  region = var.region
  zone = var.zone
}

provider "kubernetes" {
}

provider "helm" {
}

module "platform-vpc" {
  source = "./modules/vpc"
  project = var.project
  name = "${var.prefix}-${var.region}"
  subnets = [
    {
      subnet_name           = "${var.prefix}-subnet-00"
      subnet_ip             = "10.10.10.0/24"
      subnet_region         = var.region
    }
  ]
  routes = [
    {
      name                   = "${var.prefix}-egress-internet"
      description            = "route through IGW to access internet"
      destination_range      = "0.0.0.0/0"
      tags                   = "egress-inet"
      next_hop_internet      = "true"
    },
  ]
}

module "platform" {
  source = "./modules/gke-cluster"
  project = var.project
  region = var.region
  network = {
    name = module.platform-vpc.name
    subnetwork = module.platform-vpc.subnetwork
  }
  name = var.prefix
}

resource "google_compute_address" "ip_address" {
  name = "${var.prefix}-static-ip"
}
