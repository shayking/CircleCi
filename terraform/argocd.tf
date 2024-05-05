resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "6.7.18"
  values           = [templatefile("${path.module}/argo/argocd.yaml", {})]

  depends_on = [
    helm_release.aws_load_balancer_controller,
    module.eks
  ]
}
