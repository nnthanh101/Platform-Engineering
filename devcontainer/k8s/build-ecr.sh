#!/bin/bash

set -euo pipefail

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

function _logger() {
  echo -e "$(date) ${YELLOW}[*] $@ ${NC}"
}

# ./cloud9.sh

docker build --tag=buildme .
docker run --name=buildme --rm --detach buildme
docker exec -it buildme /bin/client
docker stop buildme

_logger "[+] ECR_REPO="${CONTAINER_REGISTRY_URL}/${ECR_REPOSITORY}
ECR_REPO=$(aws ecr describe-repositories | jq -c ".repositories[] | select(.repositoryName | contains(\"${ECR_REPOSITORY}\")) | .repositoryName")
if [ -z "${ECR_REPO}" ]; then
  aws ecr create-repository --repository-name ${ECR_REPOSITORY}
else
  _logger "[+] Skip creating ECR ${ECR_REPO}"
fi

aws sts get-caller-identity

echo "Login to ECR ..."
aws ecr get-login-password | docker login --password-stdin -u AWS $CONTAINER_REGISTRY_URL

echo "Login to Docker Hub ..."
echo $DOCKER_REGISTRY_PASSWORD | docker login --username $DOCKER_REGISTRY_USERNAME --password-stdin

echo "Build docker ..."
docker build -t ${ECR_REPOSITORY} -f dockerfiles/Dockerfile ./dockerfiles

echo "Tag for ECR ..."
docker tag ${ECR_REPOSITORY} ${CONTAINER_REGISTRY_URL}/${ECR_REPOSITORY}:latest
echo "Tag for Docker Hub ..."
docker tag ${ECR_REPOSITORY} ${DOCKER_REGISTRY_NAMESPACE}/${ECR_REPOSITORY}:latest

_logger "[+] Pushing Docker Image ..."
export DOCKER_IMAGE_REPOSITORY=${CONTAINER_REGISTRY_URL}/${ECR_REPOSITORY}
# export DOCKERHUB_IMAGE_REPOSITORY=${DOCKER_REGISTRY_NAMESPACE}/${ECR_REPOSITORY}

# docker push ${CONTAINER_REGISTRY_URL}/${ECR_REPOSITORY}
# docker push ${DOCKER_REGISTRY_NAMESPACE}/${ECR_REPOSITORY}

# docker pull ${DOCKER_IMAGE_REPOSITORY}:latest
docker pull ${DOCKERHUB_IMAGE_REPOSITORY}:latest

_logger "[+] Build docker-kubectl utility (CI/CD ...)"
docker build -t ${DOCKER_REGISTRY_NAMESPACE}/kubectl -f docker/kubectl/Dockerfile ./docker/kubectl
docker push ${DOCKER_REGISTRY_NAMESPACE}/kubectl

_logger "[+] Execute commands inside of the Docker ..."
echo   docker run -it -e "AWS_REGION=$AWS_REGION" --rm \
       -v "$HOME/.aws:/root/.aws" \
       -v $PWD:/project \
       ${DOCKER_IMAGE_REPOSITORY} bash -c 'chmod +x deploy.sh; ./deploy.sh'