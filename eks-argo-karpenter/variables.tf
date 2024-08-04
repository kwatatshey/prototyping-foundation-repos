
variable "resource_prefix" {
  type        = string
  description = "Prefix to be used on each infrastructure object Name created in AWS."
}
variable "environment" {
  type        = string
  description = "Environment name."
}

variable "app_name" {
  type        = string
  description = "Name of the application."
}
variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
}
variable "iac_environment_tag" {
  type        = string
  description = "AWS tag to indicate environment name of each infrastructure object."
}

variable "main_network_block" {
  type        = string
  description = "Base CIDR block to be used in our VPC."
}
variable "cluster_azs" {
  type        = list(string)
  description = "List of Availability Zones to be used in EKS"
}
variable "subnet_prefix_extension" {
  type        = number
  description = "CIDR block bits extension to calculate CIDR blocks of each subnetwork."
}
variable "zone_offset" {
  type        = number
  description = "CIDR block bits extension offset to calculate Public subnets, avoiding collisions with Private subnets."
}

variable "autoscaling_average_cpu" {
  type        = number
  description = "Average CPU threshold to autoscale EKS EC2 instances."
}
variable "spot_termination_handler_chart_name" {
  type        = string
  description = "EKS Spot termination handler Helm chart name."
}
variable "spot_termination_handler_chart_repo" {
  type        = string
  description = "EKS Spot termination handler Helm repository name."
}
variable "spot_termination_handler_chart_version" {
  type        = string
  description = "EKS Spot termination handler Helm chart version."
}
variable "spot_termination_handler_chart_namespace" {
  type        = string
  description = "Kubernetes namespace to deploy EKS Spot termination handler Helm chart."
}
# variable "dns_base_domain" {
#   type        = string
#   description = "DNS Zone name to be used from EKS Ingress."
# }
variable "ingress_gateway_name" {
  type        = string
  description = "Load-balancer service name."
}
variable "ingress_gateway_iam_role" {
  type        = string
  description = "IAM Role Name associated with load-balancer service."
}

variable "ingress_gateway_chart_name" {
  type        = string
  description = "Ingress Gateway Helm chart name."
}
variable "ingress_gateway_chart_repo" {
  type        = string
  description = "Ingress Gateway Helm repository name."
}
variable "ingress_gateway_chart_version" {
  type        = string
  description = "Ingress Gateway Helm chart version."
}
# variable "external_dns_iam_role" {
#   type        = string
#   description = "IAM Role Name associated with external-dns service."
# }
# variable "external_dns_chart_name" {
#   type        = string
#   description = "Chart Name associated with external-dns service."
# }
# variable "external_dns_chart_repo" {
#   type        = string
#   description = "Chart Repo associated with external-dns service."
# }
# variable "external_dns_chart_version" {
#   type        = string
#   description = "Chart Repo associated with external-dns service."
# }
# variable "external_dns_values" {
#   type        = map(string)
#   description = "Values map required by external-dns service."
# }

variable "admin_roles" {
  type        = list(string)
  description = "List of Kubernetes admin roles."
}

variable "cross_account_admin_roles" {
  description = "The ARN of the cross account admin role"
  type        = list(string)
}

variable "developer_roles" {
  type        = list(string)
  description = "List of Kubernetes developer roles."
}

variable "developer_users" {
  type        = list(string)
  description = "List of Kubernetes developers."
}
variable "developer_user_group" {
  type        = string
  description = "Name of the kube group for developers."
}

variable "eks_managed_node_groups" {
  type = map(object({
    ami_type       = string
    min_size       = number
    max_size       = number
    desired_size   = number
    instance_types = list(string)
    capacity_type  = string
    # use_custom_launch_template = bool
    # disk_size                  = number
    network_interfaces = list(object({
      delete_on_termination       = bool
      associate_public_ip_address = bool
    }))
  }))
  description = "List of EKS managed node groups."
}

variable "iam_role_nodes_additional_policies" {
  type        = map(string)
  description = "List of additional IAM policies to attach to EKS managed node groups."
}

variable "oic_role_configurations" {
  type = map(object({
    role_name           = string
    assume_role_actions = list(string)
    namespace           = string
    service_account     = string
    policy_file         = string
  }))
  description = "List of OIC role configurations."
}


variable "fargate_profiles" {
  type = map(object({
    name                = string
    namespace           = string
    additional_policies = map(string)
  }))
  description = "List of Fargate profiles."
}

# variable "argocd_subdomain" {
#   description = "ArgoCD subdomain"
#   type        = string
# }

variable "argocd_ingress_name" {
  description = "ArgoCD ingress"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "argocd_ingress_alb_name" {
  description = "The name of the ALB"
  type        = string
}

variable "iam_role_arn" {
  description = "Admin role ARN"
  type        = string
}

variable "project_owner_tag" {
  description = "The project owner tag"
  type        = string
  default     = "DevOps"
}

variable "project_tag" {
  description = "The project tag"
  type        = string
  default     = "Demo-Project"
}

variable "code_owner_tag" {
  description = "The code owner tag"
  type        = string
  default     = "DevOps"
}
variable "team_tag" {
  description = "The team tag"
  type        = string
  default     = "DevOps"
}
