variable "pool_machine_type" {
  default = "f1-micro"
}

variable "pool_min_node_count" {
  type = string
  default = 1
}

variable "private_key_algorithm" {
  default = "RSA"
}
variable "private_key_rsa_bits" {
  default = 4096
}
variable "pool_max_node_count" {
  type = string
  default = 3
}

variable "region" {}
variable "project" {}
variable "name" {}
variable "network" {
  type = map
}
