#!/bin/bash
set -euo pipefail

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

function _logger() {
    echo -e "$(date) ${YELLOW}[*] $@ ${NC}"
}

source .env

echo
echo "#########################################################"
echo "Verify the environment"
echo "#########################################################"
echo
kubectl version --short --client
helm version
echo $(aws sts get-caller-identity)

started_time=$(date '+%d/%m/%Y %H:%M:%S')
echo
echo "#########################################################"
echo "Infrastructure Provisioning started at ${started_time}"
echo "#########################################################"
echo

## Create S3 Bucket with Versioning Enabled to store Terraform State
echo
echo "#########################################################"
_logger "[+] 1. Initial setup S3-bucket & DynamoDB-tables for Terraform State files & locks"
echo "### Creates a s3 bucket for Terraform files..."
echo "### Creates the DynamoDB tables for Terraform locks"
echo "### Runs the the gen-backend.sh script from a Terraform null resource' "
_logger "[+] 1. Creating S3 Bucket with Versioning Enabled to store Terraform State."
echo "#########################################################"
echo
# aws sts get-caller-identity

# TF_STACK="tf-state-aws"
# cd  ${WORKING_DIR}/terraform/stacks/${TF_STACK} &&  \
#     terraform init             &&  \
#     terraform validate         &&  \
#     terraform plan -out tfplan &&  \
#     terraform apply -input=false -auto-approve tfplan

echo "TF_STATE_S3_BUCKET=${TF_STATE_S3_BUCKET} + AWS_REGION=${AWS_REGION}"
## Note: us-east-1 does not require a `location-constraint`:
aws s3api create-bucket --bucket ${TF_STATE_S3_BUCKET} --region ${AWS_REGION} --create-bucket-configuration \
    LocationConstraint=${AWS_REGION} 2>/dev/null || true
aws s3api put-bucket-versioning --bucket ${TF_STATE_S3_BUCKET} --versioning-configuration Status=Enabled 2>/dev/null || true

echo
echo "#########################################################"
_logger "[+] 2. [Networking] Provisioning Modern-VPC Stack: teraform/stacks/vpc-*/variables.tf"
_logger "2.1. Standard VPC >> Public/Private Subnet"
_logger "2.2. Private  VPC >> Private Subnet Only"
_logger "2.3. Advanced VPC >> Public/Private/Database/Cache Subnet, Flow Log, VPC Endpoint S3"
echo "#########################################################"
echo
vpc_options=("Standard VPC" "Private VPC" "Advanced VPC - Flow Log to S3" "Advanced VPC - Flow Log to CloudWatch")
PS3='Please enter your choice: '
select opt in "${vpc_options[@]}"
do
    case $REPLY in
        1)
        echo "Provisioning $opt..."
        export TF_VAR_vpc_type=$VPC_TYPE_STANDARD
        cd ${WORKING_DIR}/terraform/stacks/vpc
        ;;
        2)
        echo "Provisioning $opt..."
        export TF_VAR_vpc_type=$VPC_TYPE_PRIVATE
        cd ${WORKING_DIR}/terraform/stacks/vpc-private
        ;;
        3)
        echo "Provisioning $opt..."
        export TF_VAR_vpc_type=$VPC_TYPE_ADVANCED
        cd ${WORKING_DIR}/terraform/stacks/vpc-advanced
        ;;
        4)
        echo "Provisioning $opt..."
        export TF_VAR_vpc_type=$VPC_TYPE_ADVANCED
        export TF_VAR_vpc_flow_log_destination="cloud-watch-logs"
        cd ${WORKING_DIR}/terraform/stacks/vpc-advanced
        ;;
    esac
    break
done
terraform init -reconfigure -backend-config="region=${AWS_REGION}" -backend-config="bucket=${TF_STATE_S3_BUCKET}" -backend-config="key=${PROJECT_ID}-vpc-stack.tfstate" && \
terraform plan -out ${PROJECT_ID}.vpc.tfplan && \
terraform apply -input=false -auto-approve ${PROJECT_ID}.vpc.tfplan

## FIXME1 VPC-Endpoints
# echo
# echo "#########################################################"
# _logger "[+] 1.2. VPC Interface/Gateway Endpoints: teraform/stacks/XXX/terraform.tfvars"
# echo "#########################################################"
# echo

## FIXME2 VPC-Peering
# echo
# echo "#########################################################"
# _logger "[+] 1.3. VPC Peering: teraform/stacks/vpc-peering/terraform.tfvars"
# echo " [DevTest]      AWS-Account1-VPC1: CI/CD Pipeline - Code*, Jenkins, GitLab
# echo " [Staging/Prod] AWS-Account2-VPC2: EKS Cluster Staging/Prod
# echo "#########################################################"
# echo

# cd  ${WORKING_DIR}/terraform/stacks/vpc-peering &&           \
#     terraform init -reconfigure -backend-config="region=${AWS_REGION}" -backend-config="bucket=${TF_STATE_S3_BUCKET}" -backend-config="key=${PROJECT_ID}-vpc-peering-stack.tfstate"
#     terraform plan -out ${PROJECT_ID}.vpc-peering.tfplan &&  \
#     terraform apply -input=false -auto-approve ${PROJECT_ID}.vpc-peering.tfplan


## FIXME3 EFS
# echo
# echo "#########################################################"
# _logger "[+] 1.4. Provisioning EFS Stack: teraform/stacks/efs/terraform.tfvars"
# echo "#########################################################"
# echo

# cd  ${WORKING_DIR}/terraform/stacks/efs &&           \
#     terraform init -reconfigure -backend-config="region=${AWS_REGION}" -backend-config="bucket=${TF_STATE_S3_BUCKET}" -backend-config="key=${PROJECT_ID}-efs-stack.tfstate"
#     terraform plan -out ${PROJECT_ID}.efs.tfplan &&  \
#     terraform apply -input=false -auto-approve ${PROJECT_ID}.efs.tfplan


## FIXME4 EC2-Image-Builder
# echo
# echo "#########################################################"
# _logger "[+] 1.6. AWS EC2 Image Builder Pipeline: teraform/stacks/ec2-image-builder/terraform.tfvars"
# echo "#########################################################"
# echo

# cd  ${WORKING_DIR}/terraform/stacks/ec2-image-builder &&           \
#     terraform init -reconfigure -backend-config="region=${AWS_REGION}" -backend-config="bucket=${TF_STATE_S3_BUCKET}" -backend-config="key=${PROJECT_ID}-ec2-image-builder-stack.tfstate"
#     terraform plan -out ${PROJECT_ID}.ec2-image-builder.tfplan &&  \
#     terraform apply -input=false -auto-approve ${PROJECT_ID}.ec2-image-builder.tfplan

ended_time=$(date '+%d/%m/%Y %H:%M:%S')
echo
echo "#########################################################"
echo -e "${RED} Infrastructure Provisioning ended at ${ended_time} - ${started_time} ${NC}"
