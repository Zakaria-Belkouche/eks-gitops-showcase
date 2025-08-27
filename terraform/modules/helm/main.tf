
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "startupapicheck.timeout"
    value = "3m"
  }

  set {
    name  = "installCRDs"
    value = "true"
  }

  timeout       = 900  # 🕒 more time for CRDs + webhook
  wait_for_jobs = true # ✅ wait for startupapicheck job

  # Load values from file and inject the IRSA ARN dynamically
  values = [
    templatefile("${path.module}/cert-manager.yaml", {
    })
  ]
}

# ----------------------------------------------------------

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.11.2" # pick a stable current version for your cluster

  namespace        = "ingress-nginx"
  create_namespace = true
}

# ---------------------------------------------------------

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns"

  namespace        = "external-dns"
  create_namespace = true

  values = [file("${path.module}/values-external-dns.yaml")]
}


# ----------------------------------------------------------

resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.36.0"
  namespace  = "kube-system"

  values = [file("${path.module}/values-cluster-autoscaler.yaml")]
}

resource "helm_release" "argocd_deploy" {

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.19.15"
  timeout    = "600"

  namespace        = "argo-cd"
  create_namespace = true

  values = [file("${path.module}/argocd.yaml")]

  depends_on = [helm_release.ingress_nginx, helm_release.cert_manager]
}
