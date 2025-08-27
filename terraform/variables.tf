# Networking

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "privatesubnet_cidrs" {
  type = map(string)
  default = {
    subnet_1 = "10.0.0.0/26"
    subnet_2 = "10.0.0.64/26"
  }
}

variable "publicsubnet_cidrs" {
  type = map(string)
  default = {
    subnet_1 = "10.0.0.128/26"
    subnet_2 = "10.0.0.192/26"
  }
}

variable "subnet_az" {
  type = map(string)
  default = {
    subnet_1 = "eu-west-2a"
    subnet_2 = "eu-west-2b"
  }
}

# eks

variable "my_ip" {
  type    = list(string)
  default = ["2.102.137.209/32"]
}

variable "k8_version" {
  type    = string
  default = "1.29"
}

variable "desired_nodes" {
  type    = number
  default = 3
}

variable "max_nodes" {
  type    = number
  default = 6
}

variable "min_nodes" {
  type    = number
  default = 2
}

variable "ng_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "ng_capacity_type" {
  type    = string
  default = "ON_DEMAND"
}

variable "ng_disk_size" {
  type    = number
  default = 80
}

variable "ng_ami_type" {
  type    = string
  default = "AL2023_x86_64_STANDARD"
}

variable "max_unavailable" {
  type    = number
  default = 1
}


# irsa

variable "hostedzone_arn" {
  type    = list(string)
  default = ["arn:aws:route53:::hostedzone/Z03197441FOIGRDDOF569"]
}

variable "dns_namespace" {
  type    = list(string)
  default = ["external-dns:external-dns"]
}

variable "certmanager_namespace" {
  type    = list(string)
  default = ["cert-manager:cert-manager"]
}

# OIDC for github actions

variable "aws_region" {
  type    = string
  default = "eu-west-2"
}
variable "github_owner" {
  type    = string
  default = "Zakaria-Belkouche"
}
variable "github_repo" {
  type    = string
  default = "eks-gitops-showcase"
}
variable "github_ref" {
  type    = string
  default = "refs/heads/master"
}


variable "ecr_repo_name" {
  type    = string
  default = "space-dodger"
}

# make sure eks cluster is up before helm module runs

variable "enable_addons" {
  type    = bool
  default = true
}

