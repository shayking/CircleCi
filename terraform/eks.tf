module "eks" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=afadb14e44d1cdbd852dbae815be377c4034e82a"
  
  cluster_name    = var.cluster_name
  cluster_version = "1.23"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size = 10
  }

  eks_managed_node_groups = {
    general = {
      desired_size = 1
      min_size     = 1
      max_size     = 2

      labels = {
        role = "general"
      }

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }

  #   spot = {
  #     desired_size = 1
  #     min_size     = 1
  #     max_size     = 10

  #     labels = {
  #       role = "spot"
  #     }

  #     taints = [{
  #       key    = "market"
  #       value  = "spot"
  #       effect = "NO_SCHEDULE"
  #     }]

  #     instance_types = ["t3.micro"]
  #     capacity_type  = "SPOT"
  #   }
  }

  # node_security_group_additional_rules = {
  #   ingress_allow_access_from_control_plane = {
  #     type                          = "ingress"
  #     protocol                      = "tcp"
  #     from_port                     = 9443
  #     to_port                       = 9443
  #     source_cluster_security_group = true
  #     description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
  #   }
  # }

  tags = {
    Environment = "staging"
  }
}
