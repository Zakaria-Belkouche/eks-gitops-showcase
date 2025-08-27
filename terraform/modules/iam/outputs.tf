output "cluster_role" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "node_role" {
  value = aws_iam_role.eks_node_role.arn
}

output "github_oidc_provider_arn" { 
  value = aws_iam_openid_connect_provider.github.arn 
  }
output "github_role_arn"          { 
  value = aws_iam_role.github_ecr_pusher.arn 
  }
