ARG VARIANT="jammy"
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}
# FROM mcr.microsoft.com/devcontainers/base:jammy

# Install OS packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    make

RUN update-ca-certificates

USER vscode

ARG TERRAFORM_VERSION=1.6.3
ARG TERRAFORM_DOCS_VERSION=0.16.0
ARG TFSEC_VERSION=1.15.2
ARG TERRASCAN_VERSION=1.13.2
ARG TFLINT_AWS_RULESET_VERSION=0.21.1

RUN mkdir -p /tmp/download \
	&& cd /tmp/download \
	&& wget -O terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_1.3.6_linux_${TARGETARCH}.zip" \

# AWS CLI
SHELL ["/bin/zsh", "-c"]
RUN mkdir -p /tmp/download \
	&& cd /tmp/download \
    && ARCH=${TARGETARCH/amd64/x86_64} \

USER root

COPY post-install.sh /usr/local/bin/post-install
RUN chmod +x /usr/local/bin/post-install
