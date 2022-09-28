#!/bin/bash
set -euxo pipefail

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

function _logger() {
    echo -e "$(date) ${YELLOW}[*] $@ ${NC}"
}

## echo "This script support MacOS ONLY !!!"

KERNEL_TYPE=darwin
GO_VERSION=1.16.3
ARCH=$(uname -p)
brew install jq wget 

echo "#########################################################"
_logger "[+] 0. Installing golang"
echo "#########################################################"
curl -LO "https://golang.org/dl/go${GO_VERSION}.darwin-${ARCH}.tar.gz"
tar -C /usr/local -xvf go${GO_VERSION}.darwin-${ARCH}.tar.gz
export PATH=$PATH:/usr/local/go/bin

echo "#########################################################"
_logger "[+] 1. Installing latest AWS CLI - version 2"
echo "#########################################################"
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg ./AWSCLIV2.pkg -target /
rm -rf aws AWSCLIV2.pkg
brew tap weaveworks/tap
brew install weaveworks/tap/eksctl

echo "#########################################################"
_logger "[+] 2. Installing k9s"
echo "#########################################################"
version=$(curl https://api.github.com/repos/derailed/k9s/releases/latest --silent | jq ".tag_name" -r)
K9S_VERSION=$(echo $version | sed 's/v//g') # get rid of 'v' from version number
K9S_TAR_FILENAME=k9s_$(uname -s)_$(uname -m).tar.gz
curl -o /tmp/$K9S_TAR_FILENAME -L -k https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/$K9S_TAR_FILENAME
tar -xvf /tmp/$K9S_TAR_FILENAME -C /tmp/
sudo mv /tmp/k9s /usr/local/bin/k9s
sudo chmod +x /usr/local/bin/k9s
rm /tmp/$K9S_TAR_FILENAME

echo "#########################################################"
_logger "[+] 3. Installing kubectl"
echo "#########################################################"
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/${KERNEL_TYPE}/amd64/kubectl"
sudo mv kubectl /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl
kubectl version --client

_logger "[+] 4. Install helm-3"
git clone --depth=1 https://github.com/helm/helm helm-cli
cd helm-cli && go mod vendor && make build && sudo make install && cd .. && rm -rf helm-cli

echo "#########################################################"
_logger "[+] 5. Installing [terraform 0.14.10](https://github.com/hashicorp/terraform)"
echo "#########################################################"
cd ~
version=0.14.10
# version=$(curl https://api.github.com/repos/hashicorp/terraform/releases/latest --silent | jq ".tag_name" -r)
# version=$(echo $version | sed 's/v//g') # get rid of 'v' from version number
echo "Installing Terraform $version."
git clone --depth=1 https://github.com/hashicorp/terraform -b v$version terraform-cli
cd terraform-cli && go mod vendor && go build -o terraform.out . && sudo mv terraform.out /usr/local/bin/terraform && cd .. && rm -rf terraform-cli
echo "Terraform $version installed."

echo "[x] Verify Git client": $(git --version)
echo "[x] Verify AWS CLI version 2": $(aws --version)
# echo "[x] Verify Node.js": $(node --version)
# echo "[x] Verify CDK": $(cdk --version)
# echo "[x] Verify Python": $(python -V)
# echo "[x] Verify Python3": $(python3 -V)
# echo "[x] Verify Pip3": $(pip3 -V)
echo "[x] Verify kubectl": $(kubectl version --client)
# echo "[x] Verify eksctl": $(eksctl version)
echo "[x] Verify helm3": $(helm version --short)
echo "[x] Verify terraform": $(terraform --version)
echo "[x] Verify k9s": $(k9s version --short)
