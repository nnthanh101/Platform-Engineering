#!/bin/bash
set -e

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

function _logger() {
    echo -e "$(date) ${YELLOW}[*] $@ ${NC}"
}

source .env
param=${1:--env=dev}
parsed=(${param//=/ })
env=$(echo ${parsed[1]})
env=${env:-dev}
TF_ENV="./environment/$env"
source ${TF_ENV}/.env

aws sts get-caller-identity && sleep 1
started_time=$(date '+%d/%m/%Y %H:%M:%S')


echo
echo "#########################################################"
_logger "[+] Cleaning up started at ${started_time}"
echo "#########################################################"
echo


echo "======================================="
_logger "[+] 6. Cleaning up ${PROJECT_ID}-VPC Stack ===="
echo "======================================="

# Get current vpc type information
vpc_type=$(aws ec2 describe-vpcs --filters=Name=tag:ProjectID,Values=$PROJECT_ID |jq -r '.Vpcs[].Tags[] | select(.Key == "VPCType") | .Value' 2>/dev/null)
case $vpc_type in
    "$VPC_TYPE_STANDARD")
        echo "Destroying $vpc_type..."
        export TF_VAR_vpc_type=$VPC_TYPE_STANDARD
        cd ${WORKING_DIR}/modules/vpc
        ;;
    "$VPC_TYPE_PRIVATE")
        echo "Destroying $vpc_type..."
        export TF_VAR_vpc_type=$VPC_TYPE_PRIVATE
        cd ${WORKING_DIR}/modules/vpc-private
        ;;
    "$VPC_TYPE_ADVANCED")
        echo "Destroying $vpc_type..."
        export TF_VAR_vpc_type=$VPC_TYPE_ADVANCED
        cd ${WORKING_DIR}/modules/vpc-advanced
        ;;
esac

terraform init -reconfigure -backend-config="region=${AWS_REGION}" -backend-config="bucket=${TF_STATE_S3_BUCKET}" -backend-config="key=${PROJECT_ID}-vpc-stack.tfstate" && \
    terraform refresh && \
    terraform plan -destroy && \
    terraform destroy -auto-approve

echo "======================================="
_logger "[+] Delete ${TF_STATE_S3_BUCKET}"
echo "======================================="
aws s3api put-bucket-versioning --bucket ${TF_STATE_S3_BUCKET} --versioning-configuration Status=Suspended

echo "Removing all versions from ${TF_STATE_S3_BUCKET}"
versions=`aws s3api list-object-versions --bucket ${TF_STATE_S3_BUCKET} |jq '.Versions'`
markers=`aws s3api list-object-versions --bucket ${TF_STATE_S3_BUCKET} |jq '.DeleteMarkers'`
let count=`echo $versions |jq 'length'`-1
if [ $count -gt -1 ]; then
        echo "removing files"
        for i in $(seq 0 $count); do
                key=`echo $versions | jq .[$i].Key |sed -e 's/\"//g'`
                versionId=`echo $versions | jq .[$i].VersionId |sed -e 's/\"//g'`
                cmd="aws s3api delete-object --bucket ${TF_STATE_S3_BUCKET} --key $key --version-id $versionId"
                $cmd
        done
fi

let count=`echo $markers |jq 'length'`-1
if [ $count -gt -1 ]; then
        echo "removing delete markers"

        for i in $(seq 0 $count); do
                key=`echo $markers | jq .[$i].Key |sed -e 's/\"//g'`
                versionId=`echo $markers | jq .[$i].VersionId |sed -e 's/\"//g'`
                cmd="aws s3api delete-object --bucket ${TF_STATE_S3_BUCKET} --key $key --version-id $versionId"
                $cmd
        done
fi

sleep 15
aws s3 rm s3://${TF_STATE_S3_BUCKET}/ --recursive || true
aws s3 rb s3://${TF_STATE_S3_BUCKET} || true


ended_time=$(date '+%d/%m/%Y %H:%M:%S')
echo
echo "#########################################################"
_logger "[+] Infrastructure Provisioning ended at ${ended_time} - ${started_time}"
echo "#########################################################"
echo
