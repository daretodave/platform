resource "google_project_service" "cnrm_service" {
  project = var.project
  service = "cloudresourcemanager.googleapis.com"
}

resource "kubernetes_namespace" "cnrm_ns" {
  metadata {
    annotations = {
    }
    labels = {
    }
    name = "cnrm-system"
  }
}

module "cnrm_service_account" {
  source = "./modules/gke-service-account"

  project = var.project
  name = "cnrm-system"
  description = "Config Connector Service Account"
}

data "google_iam_policy" "cnrm_policy" {
  binding {
    role = "roles/owner"

    members = [
      "serviceAccount:${module.cnrm_service_account.email}",
    ]
  }
}

data "google_iam_policy" "cnrm_gke_policy" {
  binding {
    role = "roles/iam.workloadIdentityUser"

    members = [
      "serviceAccount:${var.project}.svc.id.goog[cnrm-system/cnrm-controller-manager]",
    ]
  }
}
