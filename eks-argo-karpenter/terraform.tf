terraform {
  required_version = ">= 1.6.6, = 1.8.1"

  backend "s3" {
    encrypt = true
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = "~> 5.0"
      version = "~> 5.0, >= 5.31.0"

    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "aws" {
  assume_role {
    # role_arn = var.admin_role_arn
    role_arn = var.iam_role_arn
  }
  # profile = "eks_admin_user"
  region = var.aws_region
  default_tags {
    tags = {
      iac_environment = var.iac_environment_tag
      ProjectOwner    = var.project_owner_tag
      Project         = var.project_tag
      Environment     = var.iac_environment_tag
      CodeOwner       = var.code_owner_tag
      Application     = var.app_name
      Team            = var.team_tag
    }
  }
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  region     = data.aws_caller_identity.current
  account_id = data.aws_caller_identity.current.account_id
}