
# module "argocd_application" {
#   source  = "git::https://github.com/project-octal/terraform-kubernetes-argocd-application.git?ref=50d4a0205efc06269a0c5453572743a5d720edbd"

#   argocd_namespace    = "argocd"
#   destination_server  = "https://kubernetes.default.svc"
#   project             = "default"
#   name                = "weatherapp"
#   namespace           = "default"
#   repo_url            = "https://${var.REPO_PAT}github.com/shayking/gitops"
#   chart               = "my-chart"
#   target_revision     = "HEAD"
#   helm_values         = {
#     "image.repository" = "shaysardam/circle-ci"
#     "image.tag"        = var.image_tag
#   }
#   automated_self_heal = true
#   automated_prune     = true


#   depends_on = [helm_release.argocd]  # Depend on 
# }
resource "helm_release" "weatherapp" {
  name       = "weatherapp"
  repository = "https://${var.REPO_PAT}@github.com/shayking/gitops/application"
  chart      = "application"
  version    = "0.1.0"
  namespace = "argocd"
}


# resource "kubernetes_secret" "repository" {
#   metadata {
#     name = "weather-app-repo"
#     namespace = "argocd"
#     labels = {
#       "argocd.argoproj.io/secret-type" = "repository"
#     }
#   }
  
#   data = {
#     url = "https://github.com/Nikxy/circleci-argocd-project.git"
#     username = var.repo_username
#     password = var.repo_key
#     type = "git"
#     project = "default"
#   }
# }


# resource "kubernetes_namespace" "weatherapp" {
#   metadata {
#     name = "weatherapp"
#   }
# }

# module "argocd_application" {
#   source = "git::https://github.com/project-octal/terraform-kubernetes-argocd-application.git?ref=50d4a0205efc06269a0c5453572743a5d720edbd"
#   argocd_namespace    = "argocd"
#   destination_server  = "https://kubernetes.default.svc"
#   project             = "default"
#   name                = "weatherapp"
#   namespace           = kubernetes_namespace.weatherapp.metadata.0.name
#   repo_url            = "https://github.com/Nikxy/circleci-argocd-project.git"
#   chart               = ""
#   path                = "app_helm"
#   target_revision     = "main"
#   helm_parameters     = [
    
#     {
#       name : "weatherApp.image"
#       value : var.image_tag
#       force_string: true
#     }
#   ]
#   automated_self_heal = true
#   automated_prune     = true
#   labels              = {
#       app = "weatherapp"
#   }
#   depends_on = [
#     kubernetes_namespace.weatherapp,
#     kubernetes_secret.repository
#   ]
# }

# resource "time_sleep" "wait" {
#   depends_on = [module.argocd_application]

#   create_duration = "10s"
# }


# data "kubernetes_ingress_v1" "weatherapp" {
#   metadata {
#     name = "weather-app-ingress"
#     namespace = "weatherapp"
#   }
#   depends_on = [
#     time_sleep.wait
#   ]
# }
