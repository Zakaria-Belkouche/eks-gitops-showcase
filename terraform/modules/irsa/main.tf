data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "tls_certificate" "oidc" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  url             = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
}


# ----------------

module "irsa_externaldns" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                     = "irsa-externaldns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = var.hostedzone_arn

  oidc_providers = {
    this = {
      provider_arn               = aws_iam_openid_connect_provider.this.arn
      namespace_service_accounts = var.dns_namespace
    }
  }
}


# ------------------

module "irsa_certmanager" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"


  role_name                  = "irsa-certmanager"
  attach_cert_manager_policy = true

  cert_manager_hosted_zone_arns = var.hostedzone_arn

  oidc_providers = {
    this = {
      provider_arn               = aws_iam_openid_connect_provider.this.arn
      namespace_service_accounts = var.cert_manager_namespace
    }
  }
}


# ---------------------

module "irsa_cluster_autoscaler" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                        = "irsa-clusterautoscaler"
  attach_cluster_autoscaler_policy = true

  cluster_autoscaler_cluster_names = [var.cluster_name]

  oidc_providers = {
    this = {
      provider_arn               = aws_iam_openid_connect_provider.this.arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }
}

# -------------------------

module "irsa_ebs_csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name             = "irsa-ebs-csi"
  attach_ebs_csi_policy = true

  oidc_providers = {
    this = {
      provider_arn               = aws_iam_openid_connect_provider.this.arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

