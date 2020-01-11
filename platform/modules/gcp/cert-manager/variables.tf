variable "acme_email" {
}
variable "acme_url" {
}
variable "namespace" {
  default = "cert-manager"
}
variable "project" {
}
variable "dns_service_account_name" {
}
variable "dns_service_account_description" {
  default = "The service account used to perform DNS01"
}
variable "credential_bucket" {
}
variable "credential_bucket_location" {
}
