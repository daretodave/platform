provider "helm" {
  namespace = var.namespace
  service_account = kubernetes_service_account.helm_account.metadata[0].name
  tiller_image = "gcr.io/kubernetes-helm/tiller:${var.helm_version}"
  install_tiller = true

  kubernetes {}
}

resource "kubernetes_service_account" "helm_account" {
  metadata {
    name = var.service_account_name
    namespace = var.namespace
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
    namespace = var.namespace
  }
}

