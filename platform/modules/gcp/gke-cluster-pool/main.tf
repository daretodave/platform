resource "google_container_node_pool" "node_pool" {
  name = var.name
  location = var.region
  cluster = var.cluster
  initial_node_count = var.min_node_count

  management {
    auto_repair = "true"
    auto_upgrade = "false"
  }

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  node_config {
    service_account = var.service_account
    machine_type = var.machine_type
    metadata = {
      disable-legacy-endpoints = "true"
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }


}
