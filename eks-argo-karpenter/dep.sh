#!/bin/bash
set -e
set -o pipefail

# Function to execute Terraform commands
run_terraform() {
    echo "Initializing Terraform..."
    terraform init

    echo "Validating Terraform configuration..."
    terraform validate

    echo "Formatting Terraform configuration..."
    terraform fmt --recursive

    echo "Refreshing Terraform state..."
    terraform refresh -var-file="$1"

    plan_file="${1##*/}"  # Extract filename from path
    plan_file="${plan_file%.tfvars}"  # Remove .tfvars extension
    plan_file="${plan_file}_${ENVIRONMENT}.tfplan"  # Add environment to filename

    echo "Plan file: $plan_file"

    echo "Generating Terraform plan..."
    terraform plan -var-file="$1" -out="$plan_file"

    read -p "Do you want to apply these changes? (yes/no): " answer
    echo "Answer: $answer"
    if [ "$answer" == "yes" ]; then
        echo "Applying Terraform changes using $1..."
        terraform apply -auto-approve -input=false -var-file="$1"
    else
        echo "No changes applied."
    fi
}

# Set environment
if [ -z "$ENVIRONMENT" ]; then
    echo "Please export the 'ENVIRONMENT' variable first."
    exit 1
fi

# Check environment and set configuration accordingly
if [ "$ENVIRONMENT" == "dev" ]; then
    # TF_BACKEND_CONFIG="environments/dev/dev.hcl"
    TF_VAR_FILE="environments/dev/dev.tfvars"
elif [ "$ENVIRONMENT" == "prd" ]; then
    # TF_BACKEND_CONFIG="environments/prd/prd.hcl"
    TF_VAR_FILE="environments/prd/prd.tfvars"
else
    echo "Invalid environment. Please use 'dev' or 'prd'."
    exit 1
fi

# Echo Environment Variables
echo "Environment Variables:"
echo "ENVIRONMENT: $ENVIRONMENT"
# echo "TF_BACKEND_CONFIG: $TF_BACKEND_CONFIG"
echo "TF_VAR_FILE: $TF_VAR_FILE"
echo

# Install and use the required Terraform version
TF_VERSION=$(cat .terraform-version)
tfenv install $TF_VERSION
tfenv use $TF_VERSION

# Run Terraform
run_terraform "$TF_VAR_FILE"
