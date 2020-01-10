

resource "google_container_cluster" "cluster" {
  name     = var.name
  location = var.region
  network  = var.network.name
  subnetwork = var.network.subnetwork
  remove_default_node_pool = true
  initial_node_count = 1

  master_auth {
    username = ""
    password = ""
  }

  addons_config {
    network_policy_config {
      disabled = "false"
    }
  }

  network_policy {
    enabled = "true"
    provider = "CALICO"
  }
}
