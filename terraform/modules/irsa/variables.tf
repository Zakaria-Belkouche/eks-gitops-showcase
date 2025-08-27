variable "hostedzone_arn" {
  type = list(string)
}

variable "cert_manager_namespace" {
  type = list(string)
}

variable "dns_namespace" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}