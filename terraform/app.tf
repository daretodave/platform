resource "google_compute_managed_ssl_certificate" "managed_certificate" {
  provider = google-beta

  name = "${element(split(".", var.platform-domain), 0)}-cert"

  managed {
    domains = [
      var.platform-domain]
  }
}

resource "google_compute_global_address" "ingress_ip" {
  name = element(split(".", var.platform-domain), 0)
}

resource "google_dns_record_set" "dns" {
  name = "${var.platform-domain}."
  type = "A"
  ttl = 300
  managed_zone = var.platform-domain-zone

  rrdatas = [
    google_compute_global_address.ingress_ip.address]
}

resource "kubernetes_service" "proxy_svc" {
  metadata {
    namespace = "default"
    name = "platform-service"
  }

  spec {
    type = "NodePort"
    session_affinity = "ClientIP"

    port {
      name = "http"
      protocol = "TCP"
      port = 80
      target_port = 8080
    }

    selector = {
      app = "platform"
    }
  }
  depends_on = [
    module.platform.cluster]
}

resource "kubernetes_ingress" "default" {
  metadata {
    name = "platform-ingress"

    annotations = {
      "ingress.kubernetes.io/force-ssl-redirect": "true"
      "ingress.gcp.kubernetes.io/pre-shared-cert" = google_compute_managed_ssl_certificate.managed_certificate.name
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.ingress_ip.name
    }
  }

  spec {
    rule {
      http {
        path {
          backend {
            service_name = kubernetes_service.proxy_svc.metadata.0.name
            service_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "platform-app" {
  metadata {
    name = "platform"
    labels = {
      app = "platform"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "platform"
      }
    }
    template {
      metadata {
        labels = {
          app = "platform"
        }
      }

      spec {
        container {
          port {
            container_port = 8080
          }
          image = "gcr.io/google-samples/hello-app:1.0"
          name = "platform"
        }
      }
    }
  }
}
