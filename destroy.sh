#!/bin/bash
set -euo pipefail

source .env
export DOCKER_IMAGE_REPOSITORY=${DOCKER_REGISTRY_NAMESPACE}/${ECR_REPOSITORY}:${DOCKER_VERSION}

docker run -it --rm \
       -v "$HOME/.aws:/root/.aws" \
       -v $PWD:/project \
       ${DOCKER_IMAGE_REPOSITORY} bash -c 'chmod +x cleanup.sh; ./cleanup.sh'
