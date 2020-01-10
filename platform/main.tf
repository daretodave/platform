module "gke_service_account" {
  source = "./modules/gcp/service-account"

  name = var.cluster_service_account_name
  project = var.project
  description = var.cluster_service_account_description
}

module "gke_cluster" {
  source = "./modules/gcp/gke-cluster"
  project = var.project
  region = var.region
  network = {
    name = module.vpc_network.name
    subnetwork = module.vpc_network.subnetwork
  }
  name = var.cluster_name
}

module "gke_cluster_pool" {
  source = "./modules/gcp/gke-cluster-pool"

  cluster = module.gke_cluster.cluster.name

  machine_type = var.cluster_pool_machine_type
  max_node_count = var.cluster_pool_max_count
  min_node_count = var.cluster_pool_min_count

  name = "${var.cluster_name}-pool-00"

  project = var.project
  region = var.region

  service_account = module.gke_service_account.email
}

module "vpc_network" {
  source = "./modules/gcp/vpc"
  project = var.project
  prefix = var.prefix
  subnets = [
    {
      subnet_name = "${var.cluster_name}-${var.region}-subnet-00"
      subnet_ip = "10.10.10.0/24"
      subnet_region = var.region
    }
  ]
  routes = [
    {
      name = "${var.cluster_name}-${var.region}-egress-internet"
      description = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags = "egress-inet"
      next_hop_internet = "true"
    },
  ]
}

module "service_ingress" {
  source = "./modules/gcp/gke-ingress"
  prefix = var.prefix
  name="service"
  namespace="service"
}

module "cert-managaer" {
  source = "./modules/gcp/cert-manager"

  acme_email = var.acme_email
  acme_url = var.acme_url
}

