resource "aws_eks_cluster" "eks" {
  name     = "eks"
  version  = var.k8_version
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = concat(var.private_subnet_ids, var.public_subnet_ids)
    endpoint_private_access = true
    endpoint_public_access  = true #will restrict to just my IP
    public_access_cidrs     = var.my_ip
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}
