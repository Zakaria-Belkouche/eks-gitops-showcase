output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "cluster_security_group_id" {
  description = "EKS-managed cluster security group ID"
  value       = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}