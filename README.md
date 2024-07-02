# acs-image-factory-terraform-modules

This repository contains all the Terraform modules used by Image Factory 2.0.

## Requirements

* Docker

## Contributing

Before doing anything, make sure that the git commit hooks are setup in your local environment by running the following:
```
git config core.hooksPath hooks
```

## Modules Catalog
| Module Name | Module URL |
| ----------- | ---------- |
| appsync-custom-domain | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/appsync-custom-domain |
| azure-packer-environment | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/azure-packer-environment |
| codepipeline-badges | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/codepipeline-badges |
| datasync-ecs-efs-s3 | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/datasync-ecs-efs-s3 |
| docker-copy-codebuild | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/docker-copy-codebuild |
| get-aws-secrets-manager-creds | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/get-aws-secrets-manager-creds |
| github-codebuild-ci | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/github-codebuild-ci |
| github-webhook-handler | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/github-webhook-handler |
| github-webhook-to-s3 | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/github-webhook-to-s3 |
| gitlab-webhook-to-s3 | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/gitlab-webhook-to-s3 |
| image-builder-scheduler | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/image-builder-scheduler |
| image-factory-buildspecs | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/image-factory-buildspecs |
| lambda-functions-ami-snapshots-lifecycle-mgmt | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/lambda-functions/ami-snapshots-lifecycle-mgmt |
| lambda-functions-check-images-status | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/lambda-functions/check-images-status |
| lambda-functions-cleanup-workflow-parameters | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/lambda-functions/cleanup-workflow-parameters |
| lambda-functions-copy-golden-image-for-org | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/lambda-functions/copy-golden-image-for-org |
| lambda-functions-copy-images-to-org-regions | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/lambda-functions/copy-images-to-org-regions |
| lambda-functions-ec2-inspector2-event-handler | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/lambda-functions/ec2-inspector2-event-handler |
| lambda-functions-ec2-test-image | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/lambda-functions/ec2-test-image |
| lambda-functions-ec2-test-image-cleanup | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/lambda-functions/ec2-test-image-cleanup |
| lambda-functions-ecr-scan-event-handler | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/lambda-functions/ecr-scan-event-handler |
| lambda-functions-eventbridge-scheduler-manual-trigger-sfn | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/lambda-functions/eventbridge-scheduler-manual-trigger-sfn |
| lambda-functions-frontend-data-submitter | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/lambda-functions/frontend-data-submitter |
| lambda-functions-share-images-to-org | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/lambda-functions/share-images-to-org |
| lambda-functions-transform-data-org-step-function | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/lambda-functions/transform-data-org-step-function |
| lambda-layers-boto3 | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/lambda-layers/boto3 |
| loadbalanced-ecs-stack | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/loadbalanced-ecs-stack |
| monitoring-and-alerts | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/monitoring-and-alerts |
| network | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/network |
| org-distribution-settings | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/org-distribution-settings |
| packer-codebuild | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/packer-codebuild |
| public-s3-bucket-cloudfront | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/public-s3-bucket-cloudfront |
| source-code-bucket | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/source-code-bucket |
| sso-integration | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/sso-integration |
| step-functions-golden-to-org-and-cross-region-copy | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/step-functions/golden-to-org-and-cross-region-copy |
| step-functions-image-builder | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/step-functions/image-builder |
| step-functions-organizations-orchestrator | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/step-functions/organizations-orchestrator |
| terraform-codepipeline | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/terraform-codepipeline |
| terraform-state-resources | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/terraform-state-resources |
| waf-resources | https://github.com/audi-acs/acs-image-factory-terraform-modules/tree/main/waf-resources |



your-project-directory/
├── config/
│   ├── kubeconfig.tpl
│   ├── argocd-tst.tf
│   ├── values/
│   │   ├── argocd-app.yaml
│   ├── sealed-secrets/
│   │   ├── sealed-ssh-secret.yaml
│   ├── ... (other configuration files)
