variable "project" {
  description = "the GCP project to deploy this demo into"
  type = string
  default = "taff-io"
}

variable "acme_email" {
  description = "the email used for acme service"
  type = string
}

variable "acme_url" {
  description = "the endpoint used to call acme service"
  type = string
  default = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

variable "region" {
  description = "the region in which to create the Kubernetes cluster"
  type = string
  default = "us-east4"
}

variable "location" {
  description = "The location (region or zone) of the GKE cluster."
  type = string
  default = "us-east4"
}

variable "cluster_name" {
  description = "the name to use when creating the GKE cluster"
  type = string
  default = "platform-cluster"
}

variable "prefix" {
  description = "used for labeling"
  type = string
  default = "platform"
}

variable "cluster_service_account_name" {
  description = "The name of the custom service account used for the GKE cluster. This parameter is limited to a maximum of 28 characters."
  type = string
  default = "platform-cluster-sa"
}

variable "cluster_service_account_description" {
  description = "A description of the custom service account used for the GKE cluster."
  type = string
  default = "A service account for use by GKE in the platform cluster."
}


variable "cluster_pool_machine_type" {
  description = "the machine type to use on the default gke node pool"
  type = string
  default = "n1-standard-1"
}

variable "cluster_pool_min_count" {
  description = "The lower threshold for horizontal scaling on the cluster"
  default = 1
  type = number
}

variable "cluster_pool_max_count" {
  description = "The upper threshold for horizontal scaling on the cluster"
  default = 3
  type = number
}

variable "helm_version" {
  default = "v2.9.1"
}
variable "helm_namespace" {
  default = "kube-system"
}
variable "helm_sa_name" {
  default = "tiller"
}
