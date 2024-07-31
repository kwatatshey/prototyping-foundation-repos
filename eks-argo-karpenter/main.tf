
module "cluster" {
  # source                         = "./base/cluster"
  source                         = "git::git@github.com:kwatatshey/prototyping-modules-repos.git//eks/base/cluster"
  cluster_name                   = var.cluster_name
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  app_name                       = var.app_name
  environment                    = var.environment
  resource_prefix                = var.resource_prefix
  developer_roles                = var.developer_roles
  developer_users                = var.developer_users
  developer_user_group           = var.developer_user_group
  enable_creation_role_with_oidc = true
  oic_role_configurations        = var.oic_role_configurations
  cluster_additional_security_group_ids = [
    module.security-alb-ingress.security_group_id,
    module.security-node.security_group_id
  ]
  #   control_plane_subnet_ids = module.vpc.private_subnets
}

module "fargate" {
  # source                    = "./base/fargate"
  source                    = "git::git@github.com:kwatatshey/prototyping-modules-repos.git//eks/base/fargate"
  for_each                  = var.fargate_profiles
  cluster_name              = module.cluster.cluster_name
  subnet_ids                = module.vpc.private_subnets
  additional_policies       = each.value.additional_policies
  fargate_profile_name      = each.value.name
  fargate_profile_namespace = each.value.namespace
  resource_prefix           = var.resource_prefix
  environment               = var.environment
  app_name                  = var.app_name
  depends_on                = [module.nodes]
}

# provision EKS cluster
module "config" {
  # source                                   = "./config/"
  source                                   = "git::git@github.com:kwatatshey/prototyping-modules-repos.git//eks/config"
  resource_prefix                          = var.resource_prefix
  environment                              = var.environment
  app_name                                 = var.app_name
  cluster_name                             = module.cluster.cluster_name
  cluster_arn                              = module.cluster.cluster_arn
  cluster_version                          = module.cluster.cluster_version
  cluster_endpoint                         = module.cluster.cluster_endpoint
  oidc_provider_arn                        = module.cluster.oidc_provider_arn
  cluster_certificate_authority_data       = module.cluster.cluster_certificate_authority_data
  spot_termination_handler_chart_name      = var.spot_termination_handler_chart_name
  spot_termination_handler_chart_repo      = var.spot_termination_handler_chart_repo
  spot_termination_handler_chart_version   = var.spot_termination_handler_chart_version
  spot_termination_handler_chart_namespace = var.spot_termination_handler_chart_namespace
  # dns_base_domain                          = var.dns_base_domain
  ingress_gateway_name          = var.ingress_gateway_name
  ingress_gateway_iam_role      = var.ingress_gateway_iam_role
  ingress_gateway_chart_name    = var.ingress_gateway_chart_name
  ingress_gateway_chart_repo    = var.ingress_gateway_chart_repo
  ingress_gateway_chart_version = var.ingress_gateway_chart_version
  # external_dns_iam_role                    = var.external_dns_iam_role
  # external_dns_chart_name                  = var.external_dns_chart_name
  # external_dns_chart_repo                  = var.external_dns_chart_repo
  # external_dns_chart_version               = var.external_dns_chart_version
  # external_dns_values                      = var.external_dns_values
  argocd_ingress_name = var.argocd_ingress_name
  # argocd_subdomain    = var.argocd_subdomain
  admin_roles     = var.admin_roles
  developer_users = var.developer_users
  developer_roles = var.developer_roles
  # karpenter_node_iam_role_name             = module.karpenter.node_iam_role_name
  developer_user_group          = var.developer_user_group
  ALB_SECURITY_GROUP_ID         = module.security-alb-ingress.security_group_id
  EKS_CLUSTER_SECURITY_GROUP_ID = module.cluster.cluster_primary_security_group_id
  vpc_id                        = module.vpc.vpc_id
  private_subnets               = module.vpc.private_subnets
  public_subnets                = module.vpc.public_subnets
  argocd_ingress_alb_name       = var.argocd_ingress_alb_name
  # grafana_api_key               = true
  security_groups = [
    module.security-alb-ingress.security_group_id,
    module.security-node.security_group_id,
    module.cluster.cluster_primary_security_group_id

  ]
}

# module "observability-accelerator" {
#   source                             = "./config/observability-accelerator"
#   cluster_name                       = module.cluster.cluster_name
#   cluster_endpoint                   = module.cluster.cluster_endpoint
#   cluster_certificate_authority_data = module.cluster.cluster_certificate_authority_data
#   # eks_cluster_id = var.eks_cluster_id
#   grafana_api_key = true

#   # other variables...
# }

module "nodes" {
  # source                            = "./base/nodes" # Update with your correct path
  source                            = "git::git@github.com:kwatatshey/prototyping-modules-repos.git//eks/base/nodes"
  for_each                          = var.eks_managed_node_groups
  cluster_version                   = module.cluster.cluster_version
  cluster_service_cidr              = module.cluster.cluster_service_cidr
  subnet_ids                        = module.vpc.private_subnets
  eks_managed_node_groups           = var.eks_managed_node_groups
  cluster_primary_security_group_id = module.cluster.cluster_primary_security_group_id
  vpc_security_group_ids = [
    module.security-alb-ingress.security_group_id,
    module.security-node.security_group_id
  ]
  name            = each.key
  app_name        = var.app_name
  environment     = var.environment
  resource_prefix = var.resource_prefix
  ami_type        = each.value["ami_type"]
  min_size        = each.value["min_size"]
  max_size        = each.value["max_size"]
  desired_size    = each.value["desired_size"]
  instance_types  = each.value["instance_types"]
  capacity_type   = each.value["capacity_type"]
  # use_custom_launch_template         = each.value["use_custom_launch_template"]
  # disk_size                          = each.value["disk_size"]
  network_interfaces                 = each.value["network_interfaces"]
  autoscaling_average_cpu            = var.autoscaling_average_cpu
  cluster_name                       = module.cluster.cluster_name
  iam_role_nodes_additional_policies = var.iam_role_nodes_additional_policies
  ebs_kms_key_arn                    = module.kms.key_arn
  tag_specifications                 = ["instance", "volume", "network-interface"]
  depends_on                         = [module.cluster]
}

module "kms" {
  # source               = "./base/nodes/kms"
  source               = "git::git@github.com:kwatatshey/prototyping-modules-repos.git//eks/base/nodes/kms"
  cluster_iam_role_arn = module.cluster.cluster_iam_role_arn
  cluster_name         = module.cluster.cluster_name
}

module "vpc" {
  # source                  = "./network/vpc"
  source                  = "git::git@github.com:kwatatshey/prototyping-modules-repos.git//network/vpc"
  resource_prefix         = var.resource_prefix
  environment             = var.environment
  app_name                = var.app_name
  main_network_block      = var.main_network_block
  cluster_azs             = var.cluster_azs
  subnet_prefix_extension = var.subnet_prefix_extension
  zone_offset             = var.zone_offset
  cluster_name            = var.cluster_name
}

module "addons" {
  # source                             = "./base/addons"
  source                             = "git::git@github.com:kwatatshey/prototyping-modules-repos.git//eks/base/addons"
  cluster_name                       = module.cluster.cluster_name
  cluster_endpoint                   = module.cluster.cluster_endpoint
  cluster_version                    = module.cluster.cluster_version
  oidc_provider_arn                  = module.cluster.oidc_provider_arn
  cluster_certificate_authority_data = module.cluster.cluster_certificate_authority_data
}

# module "irsa" {
#   source                   = "./base/irsa"
#   irsa-role-name           = "common-eks-addons-role"
#   autoscaller_cluster_name = module.cluster.cluster_name
#   oidc_provider_arn        = module.cluster.oidc_provider_arn
#   resource_prefix          = var.resource_prefix
#   environment              = var.environment
#   app_name                 = var.app_name
# }


# Module for ALB Ingress Security Group
module "security-alb-ingress" {
  # source                          = "./security"
  source                          = "git::git@github.com:kwatatshey/prototyping-modules-repos.git//security"
  environment                     = var.environment
  name                            = "${var.resource_prefix}-${var.environment}-${var.app_name}-alb-ingress"
  description                     = "Security group for ALB ingress"
  vpc_id                          = module.vpc.vpc_id
  enable_source_security_group_id = false

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTP traffic"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow SSH traffic"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTPS traffic"
    },
    {
      from_port   = 8443
      to_port     = 8443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow 8443 HTTPS traffic"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow 8080 HTTP traffic"
    },
  ]

  ingress_with_ipv6_cidr_blocks = [
    {
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      description      = "Service ports (ipv6)"
      ipv6_cidr_blocks = "::/0"
    },
    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      description      = "Service ports (ipv6)"
      ipv6_cidr_blocks = "::/0"
    },
    {
      from_port        = 8443
      to_port          = 8443
      protocol         = "tcp"
      description      = "Service ports (ipv6)"
      ipv6_cidr_blocks = "::/0"
    },
    {
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      description      = "Service ports (ipv6)"
      ipv6_cidr_blocks = "::/0"
    },
  ]

  ingress_with_self = [
    {
      from_port   = -1
      to_port     = 0
      protocol    = 0
      description = "Allow all incoming connections from this security group"
      self        = true
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Allow all outgoing connections to everywhere"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_ipv6_cidr_blocks = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "tcp"
      description      = "Service ports (ipv6)"
      ipv6_cidr_blocks = "::/0"
    },
  ]
}

# Module for Node Security Group
module "security-node" {
  # source                          = "./security"
  source                          = "git::git@github.com:kwatatshey/prototyping-modules-repos.git//security"
  environment                     = var.environment
  name                            = "${var.resource_prefix}-${var.environment}-${var.app_name}-node"
  description                     = "Security group for nodes"
  vpc_id                          = module.vpc.vpc_id
  enable_source_security_group_id = true

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTPS traffic from EKS to EKS (internal calls)"
    },
  ]

  ingress_with_ipv6_cidr_blocks = [
    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      description      = "Service ports (ipv6)"
      ipv6_cidr_blocks = "::/0"
    },
  ]

  ingress_with_source_security_group_id = [
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = -1
      description              = "Allow all incoming connections from ALB security group"
      source_security_group_id = module.security-alb-ingress.security_group_id
    },
  ]

  ingress_with_self = [
    {
      from_port   = -1
      to_port     = 0
      protocol    = 0
      description = "Allow all incoming connections from this security group"
      self        = true
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Allow all outgoing connections to everywhere"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_ipv6_cidr_blocks = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "tcp"
      description      = "Service ports (ipv6)"
      ipv6_cidr_blocks = "::/0"
    },
  ]
  depends_on = [module.security-alb-ingress]
}

module "cognito" {
  # source                            = "./auths/cognito"
  source                            = "git::git@github.com:kwatatshey/prototyping-modules-repos.git//auths/cognito"
  name                              = "cognito"
  environment                       = var.environment
  label_order                       = ["name", "environment"]
  enabled                           = true
  advanced_security_mode            = "OFF"
  domain                            = "argocdui"
  mfa_configuration                 = "ON"
  alias_attributes                  = ["email", "preferred_username"]
  allow_software_mfa_token          = true
  email_subject                     = "Sign up for <project_name>."
  enable_cognito_identity_providers = true
  users = {
    argocd-admin = {
      username = "argocd-admin"
      email    = "gauthier.kwatatshey@gmail.com"
    }
    argocd-devs = {
      username = "argocd-devs"
      email    = "kidjatgauthier@gmail.com"
    }
    argocd-ams = {
      username = "argocd-ams"
      email    = "ceoengineer1@gmail.com"
    }
  }
  user_groups = [
    {
      name        = "argocd-admin"
      description = "This is the argocd admin group"
      # The creation is part of the module if not then you parse an existing role_arn
      # If existing role then put # role_arn    = "arn:aws:iam::955769636964:role/UserPoolRole"
    },
    {
      name        = "argocd-devs"
      description = "This is the argocd developer group"
    },
    {
      name        = "argocd-ams"
      description = "This is the github admin group"
    }
  ]

  # resource_servers = [
  #   {
  #     name       = "test-pool Resource"
  #     identifier = "test-pool"
  #     scope = [
  #       {
  #         scope_name        = "read"
  #         scope_description = "can read test-pool data"
  #       },
  #       {
  #         scope_name        = "write"
  #         scope_description = "can add or change test-pool data"
  #       }
  #     ]
  #   }
  # ]

  clients = [
    {
      name                                 = "argocd"
      callback_urls                        = ["https://argocd.solutionsconsulting.net/auth/callback"]
      generate_secret                      = true
      logout_urls                          = ["https://argocd.solutionsconsulting.net/auth/logout"]
      refresh_token_validity               = 30
      allowed_oauth_flows_user_pool_client = false
      supported_identity_providers         = ["COGNITO"]
      allowed_oauth_scopes                 = ["email", "openid", "profile"]
      allowed_oauth_flows                  = ["code"]
      explicit_auth_flows                  = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
    },
    {
      name                                 = "github"
      allowed_oauth_flows                  = ["code"]
      allowed_oauth_flows_user_pool_client = true
      allowed_oauth_scopes                 = ["email", "openid", "phone"]
      callback_urls                        = ["https://localhost:3000", "https://localhost:8080"]
      explicit_auth_flows                  = ["ALLOW_CUSTOM_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
      generate_secret                      = true
      logout_urls                          = []
      access_token_validity                = 30
      id_token_validity                    = 30
      refresh_token_validity               = 30
      supported_identity_providers         = ["COGNITO"]
      prevent_user_existence_errors        = "ENABLED"
      enable_token_revocation              = true
      token_validity_units = {
        access_token  = "minutes"
        id_token      = "minutes"
        refresh_token = "days"
      }
    }
  ]
}

# data "aws_secretsmanager_secret" "ssh_private_key" {
#   name = "sshPrivateKey"
# }

# data "aws_secretsmanager_secret_version" "ssh_private_key" {
#   secret_id = data.aws_secretsmanager_secret.ssh_private_key.id
# }