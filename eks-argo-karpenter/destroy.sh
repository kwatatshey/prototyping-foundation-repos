#!/bin/bash

# Function to execute Terraform destroy command
run_terraform_destroy() {
    echo "Initializing Terraform for destroy..."
    terraform init -backend-config="$1"

    echo "Deleting AWS Load Balancer target groups..."
    load_balancer_arn=$(aws elbv2 describe-load-balancers --names argocd-alb --query 'LoadBalancers[0].LoadBalancerArn' --output text)
    if [[ -n "$load_balancer_arn" ]]; then
        target_group_arns=$(aws elbv2 describe-target-groups --load-balancer-arn "$load_balancer_arn" --query 'TargetGroups[*].TargetGroupArn' --output text)
        for target_group_arn in $target_group_arns; do
            echo "Deleting target group $target_group_arn..."
            aws elbv2 delete-target-group --target-group-arn "$target_group_arn"
        done
    else
        echo "No load balancer found with name 'argocd-alb'. Skipping target group deletion."
    fi

    if [[ -n "$load_balancer_arn" ]]; then
        echo "Deleting AWS Load Balancer..."
        aws elbv2 delete-load-balancer --load-balancer-arn "$load_balancer_arn"
    else
        echo "No load balancer found with name 'argocd-alb'. Skipping load balancer deletion."
    fi

    # Uncomment the following section if you want to perform ArgoCD resource deletion
    # echo "Deleting ArgoCD resources..."
    # kubectl patch ingress argocd-ingress -n argocd -p '{"metadata":{"finalizers":[]}}' --type=merge
    # kubectl delete ingress argocd-ingress -n argocd
    # echo "Deleting ArgoCD namespace..."
    # export NAMESPACE=argocd
    # kubectl get namespace $NAMESPACE -o json > $NAMESPACE.json
    # sed -i -e 's/"kubernetes"//' $NAMESPACE.json
    # kubectl replace --raw "/api/v1/namespaces/$NAMESPACE/finalize" -f ./$NAMESPACE.json
    # kubectl delete namespace $NAMESPACE

    echo "Terraform refresh..."
    terraform refresh -var-file="$2"

    echo "Planning Terraform destroy..."
    read -p "Do you want to proceed with destroying these resources? (yes/no): " answer
    if [ "$answer" == "yes" ]; then
        echo "Destroying Terraform resources..."
        terraform destroy -auto-approve -var-file="$2"
    else
        echo "Destroy operation aborted."
    fi
}

# Set environment
if [ -z "$ENVIRONMENT" ]; then
    echo "Please export the 'ENVIRONMENT' variable first."
    exit 1
fi

# Check environment and set configuration accordingly
if [ "$ENVIRONMENT" == "dev" ]; then
    TF_BACKEND_CONFIG="environments/dev/dev.hcl"
    TF_VAR_FILE="environments/dev/dev.tfvars"
elif [ "$ENVIRONMENT" == "prod" ]; then
    TF_BACKEND_CONFIG="environments/prod/prod.hcl"
    TF_VAR_FILE="environments/prod/prod.tfvars"
else
    echo "Invalid environment. Please use 'dev' or 'prod'."
    exit 1
fi

# Echo Environment Variables
echo "Environment Variables:"
echo "ENVIRONMENT: $ENVIRONMENT"
echo "TF_BACKEND_CONFIG: $TF_BACKEND_CONFIG"
echo "TF_VAR_FILE: $TF_VAR_FILE"
echo

# Install and use the required Terraform version
TF_VERSION=$(cat .terraform-version)
tfenv install "$TF_VERSION"
tfenv use "$TF_VERSION"

# Run Terraform destroy
run_terraform_destroy "$TF_BACKEND_CONFIG" "$TF_VAR_FILE"
