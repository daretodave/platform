data "google_client_config" "current" {}

output "client_certificate" {
  value = base64decode(google_container_cluster.cluster.master_auth[0].client_certificate)
}

output "client_key" {
  value = base64decode(google_container_cluster.cluster.master_auth[0].client_key)
}

output "cluster_ca_certificate" {
  value = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
}

output "cluster" {
  value = google_container_cluster.cluster
}

output "endpoint" {
  value = google_container_cluster.cluster.endpoint
}

output "token" {
  value = data.google_client_config.current.access_token
}
