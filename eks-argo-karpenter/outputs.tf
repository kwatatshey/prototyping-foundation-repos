output "alb_ingress_security_group_id" {
  description = "The security group id for the ALB ingress controller"
  value       = module.security_alb_ingress.security_group_id
}
output "node_security_group_id" {
  description = "The security group id for the EKS nodes"
  value       = module.security_node.security_group_id
}
output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = module.cluster.cluster_endpoint
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.cluster.cluster_name
}

output "public_subnets" {
  description = "The public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "The private subnets"
  value       = module.vpc.private_subnets
}

# Cognito
output "user_pool" {
  description = "All outputs exposed by the module."
  value       = merge(module.cognito, { client_secrets = null })
}
