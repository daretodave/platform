resource "google_compute_address" "ingress_address" {
  name = "${var.prefix}-${var.name}-ingress"
  address_type = "EXTERNAL"
}

resource "helm_release" "nginx-ingress" {
  chart = "stable/nginx-ingress"
  name  = var.name
  namespace = var.namespace

  set {
    name  = "controller.service.loadBalancerIP"
    value = google_compute_address.ingress_address.address
  }

}


