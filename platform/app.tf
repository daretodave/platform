resource "google_compute_global_address" "ingress_ip" {
  name = "platform-service-ip"
}

resource "kubernetes_service" "app_svc" {
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
    module.gke_cluster.cluster]
}

resource "kubernetes_ingress" "default" {
  metadata {
    name = "platform-ingress"

    annotations = {
      "ingress.kubernetes.io/force-ssl-redirect": "true"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.ingress_ip.name
    }
  }

  spec {
    tls {
      hosts = [
        "ping.service.taff.io"
      ]
      secret_name = "platform-service-ingress-tls"
    }
    rule {
      host = "ping.service.taff.io"
      http {
        path {
          backend {
            service_name = kubernetes_service.app_svc.metadata.0.name
            service_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "app_deployment" {
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

resource "google_dns_record_set" "dns" {
  name = "*.service.taff.io."
  type = "A"
  ttl = 300
  managed_zone = "taff-io"
  rrdatas = [
    google_compute_global_address.ingress_ip.address
  ]
}
