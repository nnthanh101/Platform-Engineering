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
_logger "[+] Creating S3 Bucket with Versioning Enabled to store Terraform State."
echo "#########################################################"
echo
# aws sts get-caller-identity

echo "TF_STATE_S3_BUCKET=${TF_STATE_S3_BUCKET} + AWS_REGION=${AWS_REGION}"
## Note: us-east-1 does not require a `location-constraint`:
# aws s3api create-bucket --bucket ${TF_STATE_S3_BUCKET} --region ${AWS_REGION} --create-bucket-configuration || true
aws s3api create-bucket --bucket ${TF_STATE_S3_BUCKET} --region ${AWS_REGION} --create-bucket-configuration \
    LocationConstraint=${AWS_REGION} || true
aws s3api put-bucket-versioning --bucket ${TF_STATE_S3_BUCKET} --versioning-configuration Status=Enabled


echo
echo "#########################################################"
_logger "[+] 1.1. [AWS-Infra] Provisioning Modern-VPC Stack: teraform/stacks/vpc/terraform.tfvars"
_logger "1.1.1. Standard VPC >> "
echo    "1.1.2. Private  VPC >> "
echo    "1.1.3. Advanced VPC >> "
echo "#########################################################"
echo

# echo "WORKING_DIR="${WORKING_DIR}
# read -p "[Modern-VPC] Press key to continue.. " -n1 -s
# sleep 15

cd  ${WORKING_DIR}/terraform/stacks/vpc &&           \
    terraform init -reconfigure -backend-config="region=${AWS_REGION}" -backend-config="bucket=${TF_STATE_S3_BUCKET}" -backend-config="key=${PROJECT_ID}-vpc-stack.tfstate" && \
    terraform plan -out ${PROJECT_ID}.vpc.tfplan &&  \
    terraform apply -input=false -auto-approve ${PROJECT_ID}.vpc.tfplan

## FIXME3 VPC-Endpoints
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


## FIXME1 EFS
# echo
# echo "#########################################################"
# _logger "[+] 1.4. Provisioning EFS Stack: teraform/stacks/efs/terraform.tfvars"
# echo "#########################################################"
# echo

# cd  ${WORKING_DIR}/terraform/stacks/efs &&           \
#     terraform init -reconfigure -backend-config="region=${AWS_REGION}" -backend-config="bucket=${TF_STATE_S3_BUCKET}" -backend-config="key=${PROJECT_ID}-efs-stack.tfstate"
#     terraform plan -out ${PROJECT_ID}.efs.tfplan &&  \
#     terraform apply -input=false -auto-approve ${PROJECT_ID}.efs.tfplan


ended_time=$(date '+%d/%m/%Y %H:%M:%S')
echo
echo "#########################################################"
echo -e "${RED} Infrastructure Provisioning ended at ${ended_time} - ${started_time} ${NC}"
