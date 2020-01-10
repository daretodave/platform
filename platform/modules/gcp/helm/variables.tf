variable "helm_version" {
  default = "v2.9.1"
}

variable "service_account_name" {
  default = "tiller"
}

variable "kubernetes" {
  type = object({
    host: string,
    token: string,
    client_certificate: string,
    client_key: string
    cluster_ca_certificate: string
  })
}
