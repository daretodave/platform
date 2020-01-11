data "template_file" "cert_manager_crds" {
  template = file("${path.module}/00-crds.yaml")
}

resource "null_resource" "cert_manager_crds_apply" {
  triggers = {
    manifest_sha1 = sha1(data.template_file.cert_manager_crds.rendered)
  }
  provisioner "local-exec" {
    command = "kubectl apply --validate=false -f ${path.module}/00-crds.yaml"
  }
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.namespace
  }
}

module "dns_service_account" {
  source = "../service-account"

  project = var.project

  name = var.dns_service_account_name
  description = var.dns_service_account_description
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/dns.admin"

    members = [
      "serviceAccount:${var.dns_service_account_name}@y${var.project}}.iam.gserviceaccount.com",
    ]
  }
}

resource "google_service_account_key" "admin_key" {
  service_account_id = module.dns_service_account.id
}

data "google_storage_transfer_project_service_account" "default" {
  project = var.project
}


resource "google_storage_bucket" "storage_bucket" {
  project       = var.project
  name          = var.credential_bucket
  location      = var.credential_bucket_location
}

resource "google_storage_bucket_object" "account_auth" {
  name          = "${var.dns_service_account_name}-auth.json"
  content       =  base64decode(google_service_account_key.admin_key.private_key)
  bucket        = google_storage_bucket.storage_bucket.name
}

data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

resource "helm_release" "cert-manager" {
  namespace = var.namespace
  repository = data.helm_repository.jetstack.metadata[0].name
  name  = "cert-manager"
  chart = "cert-manager"
  version = "v0.12.0"
}
