#!/bin/bash
set -euo pipefail

ENV="dev"
TF_ENV="./environment/$ENV"
source ${TF_ENV}/.env

export DOCKER_IMAGE_REPOSITORY=${DOCKER_REGISTRY_NAMESPACE}/${ECR_REPOSITORY}:${DOCKER_VERSION}

docker run -it --rm \
       -v "$HOME/.aws:/root/.aws" \
       -v $PWD:/project \
       -e ENV=$ENV \
       ${DOCKER_IMAGE_REPOSITORY} bash -c 'chmod +x bootstrap.sh; ./bootstrap.sh -env=$ENV'
