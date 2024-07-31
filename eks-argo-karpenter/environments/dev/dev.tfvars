#------------------------------------------------------------------------------
# PROVIDERS ASSUME ROLE
#------------------------------------------------------------------------------
iam_role_arn = "arn:aws:iam::537643952306:role/deployment-assumable-dev-prototyping"

#------------------------------------------------------------------------------
# VPC VALUES - BASE MODULE
#------------------------------------------------------------------------------
resource_prefix     = "fed"
environment         = "dev"
app_name            = "k8s"
cluster_name        = "my-app-eks"
iac_environment_tag = "dev"

main_network_block      = "10.0.0.0/16"
cluster_azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
subnet_prefix_extension = 4
zone_offset             = 8


#------------------------------------------------------------------------------
# EKS VALUES - BASE MODULE
#------------------------------------------------------------------------------
autoscaling_average_cpu = 30
eks_managed_node_groups = {
  "my-app-eks-x86" = {
    ami_type     = "AL2_x86_64"
    min_size     = 3
    max_size     = 16
    desired_size = 3
    instance_types = [
      "t3.small",
      "t3.medium",
      "t3.large",
      "t3a.small",
      "t3a.medium",
      "t3a.large",
      "t3.xlarge"
    ]
    capacity_type = "SPOT"
    # use_custom_launch_template = false
    # disk_size                  = 300
    network_interfaces = [{
      delete_on_termination       = true
      associate_public_ip_address = true
    }]
  }
  "my-app-eks-arm" = {
    ami_type     = "AL2_ARM_64"
    min_size     = 3
    max_size     = 16
    desired_size = 3
    instance_types = [
      "c7g.medium",
      "c7g.large"
    ]
    capacity_type = "ON_DEMAND"
    # use_custom_launch_template = false
    # disk_size                  = 300
    network_interfaces = [{
      delete_on_termination       = true
      associate_public_ip_address = true
    }]
  }
}

iam_role_nodes_additional_policies = {
  worker_node_policy                  = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
  cni_policy                          = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  cloudwatch_agent_policy             = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  ssm_managed_instance_core_policy    = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  vpc_resource_controller_policy      = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
  AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
  CloudWatchFullAccess                = "arn:aws:iam::aws:policy/CloudWatchFullAccess",
  CloudWatchLogsFullAccess            = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
  AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"

}

#------------------------------------------------------------------------------
# EKS VALUES - CONFIG MODULE
#------------------------------------------------------------------------------
spot_termination_handler_chart_name      = "aws-node-termination-handler"
spot_termination_handler_chart_repo      = "https://aws.github.io/eks-charts"
spot_termination_handler_chart_version   = "0.21.0"
spot_termination_handler_chart_namespace = "kube-system"

#------------------------------------------------------------------------------
# EXTERNAL DNS - CONFIG MODULE
#------------------------------------------------------------------------------
# external_dns_iam_role      = "external-dns"
# external_dns_chart_name    = "external-dns"
# external_dns_chart_repo    = "https://kubernetes-sigs.github.io/external-dns/"
# external_dns_chart_version = "1.9.0"

# external_dns_values = {
#   "image.repository"   = "k8s.gcr.io/external-dns/external-dns",
#   "image.tag"          = "v0.11.0",
#   "logLevel"           = "info",
#   "logFormat"          = "json",
#   "triggerLoopOnEvent" = "true",
#   "interval"           = "5m",
#   "policy"             = "sync",
#   "sources"            = "{ingress}"
# }

#------------------------------------------------------------------------------
# IAM - CONFIG MODULE
#------------------------------------------------------------------------------
admin_roles          = ["eks-admin-role", "deployment-assumable-dev-prototyping"]
developer_users      = ["Terraform", "tst"]
developer_roles      = ["CrossplaneRole"]
developer_user_group = "devepers-user-group"


#------------------------------------------------------------------------------
# INGRESS - CONFIG MODULE
#------------------------------------------------------------------------------
# dns_base_domain          = "solutionsconsulting.net"
ingress_gateway_name     = "aws-load-balancer-controller"
ingress_gateway_iam_role = "aws-load-balancer-controller"


ingress_gateway_chart_name    = "aws-load-balancer-controller"
ingress_gateway_chart_repo    = "https://aws.github.io/eks-charts"
ingress_gateway_chart_version = "1.4.1"

#------------------------------------------------------------------------------
# NAMESPACE - CONFIG MODULE
#------------------------------------------------------------------------------



oic_role_configurations = {
  aws-load-balancer-controller-argocd = {
    role_name           = "aws-load-balancer-controller"
    assume_role_actions = ["sts:AssumeRoleWithWebIdentity"]
    service_account     = "aws-load-balancer-controller"
    namespace           = "argocd"
    policy_file         = "aws-load-balancer-controller.json"
  }
  # aws-load-balancer-controller-kube-system = {
  #   role_name           = "aws-load-balancer-controller-kube-system"
  #   assume_role_actions = ["sts:AssumeRoleWithWebIdentity"]
  #   service_account     = "aws-load-balancer-controller"
  #   namespace           = "kube-system"
  #   policy_file         = "aws-load-balancer-controller.json"
  # }
}


fargate_profiles = {
  "argocd" = {
    name      = "argocd"
    namespace = "argocd"
    additional_policies = {
      "AmazonEKSFargatePodExecutionRolePolicy" = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
    }
  }
  "nginx" = {
    name      = "nginx"
    namespace = "nginx"
    additional_policies = {
      "AmazonEKSFargatePodExecutionRolePolicy" = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
    }
  }
  # "monitoring" = {
  #   name      = "monitoring"
  #   namespace = "monitoring"
  #   additional_policies = {
  #     "AmazonEKSFargatePodExecutionRolePolicy" = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  #   }
  # }
}

# argocd_subdomain        = "argocd"
argocd_ingress_name     = "argocd-ingress"
argocd_ingress_alb_name = "argocd-alb"
