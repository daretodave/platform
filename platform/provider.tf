provider "google" {
  project = var.project
  region  = var.region
}

provider "google-beta" {
  project = var.project
  region  = var.region

}

provider kubernetes {}

provider "helm" {
  namespace = var.helm_namespace
  service_account = kubernetes_service_account.helm_account.metadata[0].name
  tiller_image = "gcr.io/kubernetes-helm/tiller:${var.helm_version}"
  install_tiller = true
}

resource "kubernetes_service_account" "helm_account" {
  metadata {
    name = var.helm_sa_name
    namespace = var.helm_namespace
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "helm_role_binding" {
  metadata {
    name = kubernetes_service_account.helm_account.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind = "ServiceAccount"
    name      = kubernetes_service_account.helm_account.metadata[0].name
    namespace = var.helm_namespace
  }
}
