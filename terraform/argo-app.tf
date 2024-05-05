variable "image_tag" {
  type = string
}

module "argocd_application" {
  source  = "git::https://github.com/project-octal/terraform-kubernetes-argocd-application.git?ref=50d4a0205efc06269a0c5453572743a5d720edbd"
  version = "2.0.0"

  argocd_namespace    = "argocd"
  destination_server  = "https://kubernetes.default.svc"
  project             = "default"
  name                = "weatherapp"
  namespace           = "default"
  repo_url            = "https://github.com/shayking/gitops"
  chart               = "my-chart"
  target_revision     = "HEAD"
  helm_values         = {
    "image.repository" = "shaysardam/circle-ci"
    "image.tag"        = var.image_tag
  }
  automated_self_heal = true
  automated_prune     = true
}
