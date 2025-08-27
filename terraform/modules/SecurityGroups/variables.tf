variable "vpc_id" {
  type = string
}

variable "cluster_security_group_id" {
  description = "EKS cluster (control-plane) SG id, used to allow kubelet 10250"
  type        = string
}