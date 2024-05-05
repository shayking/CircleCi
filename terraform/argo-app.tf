variable "image_tag" {
  type = string
}

module "argocd_application" {
  source  = "project-octal/argocd-application/kubernetes"
  version = "2.0.0"

  argocd_namespace    = "argocd"
  destination_server  = "https://kubernetes.default.svc"
  project             = module.project.name
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
