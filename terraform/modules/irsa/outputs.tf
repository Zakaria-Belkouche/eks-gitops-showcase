output "externaldns_role_arn" {
  value       = module.irsa_externaldns.iam_role_arn
  description = "IAM role ARN to annotate on the external-dns ServiceAccount"
}

output "certmanager_role_arn" {
  value       = module.irsa_certmanager.iam_role_arn
  description = "IAM role ARN for cert-manager (DNS-01)"
}

output "cluster_autoscaler_role_arn" {
  value       = module.irsa_cluster_autoscaler.iam_role_arn
  description = "IAM role ARN for Cluster Autoscaler"
}

output "ebs_csi_role_arn" {
  value       = module.irsa_ebs_csi.iam_role_arn
  description = "IAM role ARN for the EBS CSI controller SA"
}