FROM alpine:3.13

LABEL maintainer="nnthanh101@gmail.com"
LABEL version="1.0.1"
LABEL description="Cross-Platform bootstrapping to deploy Terraform execution environment."

## [Terraform 0.14.10](https://github.com/hashicorp/terraform/releases)
## [Packer 1.7.2]https://github.com/hashicorp/packer/releases
## [helmmans 3.6.7](https://github.com/Praqma/helmsman/releases)
## [aws-iam-authenticator 1.19.6/2021-01-05](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
ARG TERRAFORM_VERSION=0.15.0
ARG PACKER_VERSION=1.7.2
ARG HELMSMAN_VERSION=3.6.7
ARG AWS_IAM_AUTH_VERSION=1.19.6/2021-01-05

ENV TZ=Asia/Bangkok
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apk --update-cache upgrade && \
    apk add --update --no-cache bash curl wget unzip git openssl jq docker-cli

RUN apk --no-cache add \
    binutils \
    && GLIBC_VER=$(curl -s https://api.github.com/repos/sgerrand/alpine-pkg-glibc/releases/latest | grep tag_name | cut -d : -f 2,3 | tr -d \",' ') \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && apk add --no-cache \
    glibc-${GLIBC_VER}.apk \
    glibc-bin-${GLIBC_VER}.apk \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
    awscliv2.zip \
    aws \
    /usr/local/aws-cli/v2/*/dist/aws_completer \
    /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
    /usr/local/aws-cli/v2/*/dist/awscli/examples \
    && apk --no-cache del \
    binutils \
    && rm glibc-${GLIBC_VER}.apk \
    && rm glibc-bin-${GLIBC_VER}.apk \
    && rm -rf /var/cache/apk/*

RUN /usr/local/bin/aws --version

## Install Terraform
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip ./terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/

## Install Kubectl (same version of AWS EKS)
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
        mv kubectl /usr/local/bin/kubectl && \
        chmod +x /usr/local/bin/kubectl

## Install Helm3
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

## Install Helm-diff plugin
RUN helm plugin install https://github.com/databus23/helm-diff --version master

## Install Helmsman
RUN curl -L https://github.com/Praqma/helmsman/releases/download/v${HELMSMAN_VERSION}/helmsman_${HELMSMAN_VERSION}_linux_amd64.tar.gz | tar zx && \
    chmod +x helmsman && \
    mv ./helmsman /usr/local/bin/helmsman
    
## Install aws-iam-authenticator
RUN curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/${AWS_IAM_AUTH_VERSION}/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x ./aws-iam-authenticator && \
    mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator 
    
## Install Packer
RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip && \
    chmod +x packer && \
    mv ./packer /usr/local/bin/packer

VOLUME  /root/.aws
VOLUME  /project
WORKDIR /project
