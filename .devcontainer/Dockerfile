ARG DEBIAN_FRONTEND=noninteractive
ARG VARIANT="jammy"

FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}
# FROM mcr.microsoft.com/devcontainers/base:${VARIANT}

LABEL maintainer="nnthanh101@gmail.com"
LABEL version="1.0.1"

# ARG USERNAME=vscode
# ARG USER_UID=1000
# ARG USER_GID=$USER_UID

ENV LANG=C.UTF-8
ENV TZ=Pacific/Auckland
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# SHELL ["/bin/bash", "-o", "pipefail", "-c"]

## Minimal Ubuntu https://wiki.ubuntu.com/Minimal
RUN apt-get update && yes | unminimize

## Install OS packages
RUN apt-get update -qq &&   \
    apt-get install -y --no-install-recommends \
      make yarn imagemagick \
      postgresql-client     \
      libsqlite3-dev        \
    && rm -rf /var/lib/apt/lists/*             \
    && apt-get clean

RUN update-ca-certificates

RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip \
  && unzip ngrok-stable-linux-amd64.zip \
  && mv ngrok /usr/local/bin \
  && rm ngrok-stable-linux-amd64.zip

RUN echo "$(ngrok --version)"

# RUN pip install --upgrade pip

USER vscode
RUN echo "USER vscode ..."

# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# ARG TERRAFORM_VERSION=1.6.3
# ARG TERRAFORM_DOCS_VERSION=0.16.0
# ARG TFSEC_VERSION=1.15.2
# ARG TERRASCAN_VERSION=1.13.2
# ARG TFLINT_AWS_RULESET_VERSION=0.21.1

# RUN mkdir -p /tmp/download \
# 	&& cd /tmp/download \
# 	&& wget -O terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_1.3.6_linux_${TARGETARCH}.zip" \

# # AWS CLI
# SHELL ["/bin/zsh", "-c"]
# RUN mkdir -p /tmp/download \
# 	&& cd /tmp/download \
#     && ARCH=${TARGETARCH/amd64/x86_64} \

USER root
RUN echo "root ..."

# RUN jupyter labextension install \
#     ## File managers and openers
#     jupyterlab-python-file       \
#     ## other extensions
#     @jupyterlab/toc              \
#     jupyterlab-plotly            \
#     @jupyter-widgets/jupyterlab-manager \
#     jupyter-matplotlib

# RUN groupadd devsecops \
#     && usermod -g devsecops -a -G users devsecops
# 
# USER devsecops

COPY post-install.sh /usr/local/bin/post-install
RUN chmod +x /usr/local/bin/post-install
RUN echo "./post-install ..."

# ENV HOME /root
# WORKDIR /root/