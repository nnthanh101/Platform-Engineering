FROM alpine:3.18

LABEL maintainer="nnthanh101@gmail.com"
LABEL version="1.0.1"
LABEL description="Cross-Platform bootstrapping to deploy AWS Terraform execution environment."

ARG ARCH

ENV LANG=C.UTF-8
ENV TZ=Pacific/Auckland
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

## Install jq, yq, gettext (for envsubst), curl, ca-certificates, bash, git
RUN apk --update-cache upgrade && \
    apk add --update --no-cache jq yq gettext curl ca-certificates bash git tar wget unzip
    # apk add --update --no-cache jq yq gettext curl ca-certificates bash git tar wget unzip python3 gzip gawk openssl docker-cli

## Ignore to update versions here
# docker build --no-cache --build-arg KUBECTL_VERSION=${tag} --build-arg HELM_VERSION=${helm} --build-arg KUSTOMIZE_VERSION=${kustomize_version} -t ${image}:${tag} .
ARG HELM_VERSION=3.13.1
ARG HELMSMAN_VERSION=3.6.7
ARG KUBECTL_VERSION=1.17.5
ARG KUSTOMIZE_VERSION=v5.2.1
# ARG KUBESEAL_VERSION=0.18.1
# ARG KREW_VERSION=v0.4.4
# ARG VALS_VERSION=0.28.1

## Install helm (latest release)
# ENV BASE_URL="https://storage.googleapis.com/kubernetes-helm"
RUN case `uname -m` in \
    x86_64) ARCH=amd64; ;; \
    armv7l) ARCH=arm; ;; \
    aarch64) ARCH=arm64; ;; \
    ppc64le) ARCH=ppc64le; ;; \
    s390x) ARCH=s390x; ;; \
    *) echo "un-supported arch, exit ..."; exit 1; ;; \
    esac && \
    echo "export ARCH=$ARCH" > /envfile && \
    cat /envfile

## Install Helm
RUN . /envfile && echo $ARCH && \
    apk add --update --no-cache curl ca-certificates bash git && \
    curl -sL https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCH}.tar.gz | tar -xvz && \
    mv linux-${ARCH}/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-${ARCH}
# RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
#     chmod 700 get_helm.sh && \
#     ./get_helm.sh

## Install Helm-diff plugin
RUN helm plugin install https://github.com/databus23/helm-diff --version master && rm -rf /tmp/helm-*

## Install [Helmsman](https://github.com/Praqma/helmsman/releases)
RUN curl -L https://github.com/Praqma/helmsman/releases/download/v${HELMSMAN_VERSION}/helmsman_${HELMSMAN_VERSION}_linux_amd64.tar.gz | tar zx && \
    chmod +x helmsman && \
    mv ./helmsman /usr/local/bin/helmsman

## Install kustomize (latest release)
RUN . /envfile && echo $ARCH && \
    curl -sLO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_${ARCH}.tar.gz && \
    tar xvzf kustomize_${KUSTOMIZE_VERSION}_linux_${ARCH}.tar.gz && \
    mv kustomize /usr/bin/kustomize && \
    chmod +x /usr/bin/kustomize && \
    rm kustomize_${KUSTOMIZE_VERSION}_linux_${ARCH}.tar.gz

## Install Kubectl (same version of AWS EKS)
RUN . /envfile && echo $ARCH && \
    curl -sLO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl && \
    mv kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

## Install Eksctl (latest version)
RUN . /envfile && echo $ARCH && \
    curl -sL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_${ARCH}.tar.gz" | tar xz -C /tmp && \
    mv /tmp/eksctl /usr/bin && \
    chmod +x /usr/bin/eksctl

## Install AWSCLI v2
RUN apk add --update --no-cache python3 && \
    python3 -m ensurepip && \
    pip3 install --upgrade pip setuptools && \
    pip3 install awscliv2 && \
    pip3 cache purge

## https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
## Install aws-iam-authenticator (latest version)
RUN . /envfile && echo $ARCH && \
    authenticator=$(curl -fs https://api.github.com/repos/kubernetes-sigs/aws-iam-authenticator/releases/latest | jq --raw-output '.name' | sed 's/^v//') && \
    curl -fL https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${authenticator}/aws-iam-authenticator_${authenticator}_linux_${ARCH} -o /usr/bin/aws-iam-authenticator && \
    chmod +x /usr/bin/aws-iam-authenticator

## [Terraform 1.6.3](https://github.com/hashicorp/terraform/releases)
## [Packer 1.9.4](https://github.com/hashicorp/packer/releases)
ARG TERRAFORM_VERSION=1.6.3
ARG PACKER_VERSION=1.9.4

## Install Terraform
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip ./terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/

## Install Packer
RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip && \
    chmod +x packer && \
    mv ./packer /usr/local/bin/packer

VOLUME  /root/.aws
VOLUME  /apps
WORKDIR /apps