resource "google_compute_address" "ingress_address" {
  name = "${var.prefix}-${var.name}-ingress"
  address_type = "EXTERNAL"
}

resource "helm_release" "nginx-ingress" {
  namespace = var.namespace
  name  = var.name
  chart = "stable/nginx-ingress"

  set {
    name  = "controller.service.loadBalancerIP"
    value = google_compute_address.ingress_address.address
  }

}


