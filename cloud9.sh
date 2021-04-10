#!/bin/bash
set -euxo pipefail

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

function _logger() {
    echo -e "$(date) ${YELLOW}[*] $@ ${NC}"
}

## echo "This script support Amazon Linux 2 ONLY !!!"

KERNEL_TYPE=linux
sudo yum install -y jq gettext bash-completion
# if [[ "$OSTYPE" == "linux-gnu"* ]]; then
#     echo "Linux OS"
#     DISTRO_ID=$(lsb_release -si)
#     if [[ "$DISTRO_ID" == "Ubuntu" ]]; then
#         echo "Install with apt"
#         sudo apt-get install -y apache2-utils jq gettext bash-completion
#     elif [[ "$DISTRO_ID" == "AmazonLinux"* ]]; then
#         echo "Install with yum"
#         sudo yum install -y jq gettext bash-completion
#     else
#         echo "error can't install package"
#         exit 1;
#     fi
# elif [[ "$OSTYPE" == "darwin"* ]]; then
#     brew install jq wget
#     KERNEL_TYPE=darwin
# else
#     echo "Unsupport platform: $OSTYPE"
#     exit 1
# fi

echo "#########################################################"
_logger "[+] 1. Installing latest AWS CLI - version 2"
echo "#########################################################"
# if [[ "$KERNEL_TYPE" == "linux" ]]; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install --update
    rm -rf awscliv2.zip aws
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    sudo mv /tmp/eksctl /usr/local/bin
# else
#     curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
#     sudo installer -pkg ./AWSCLIV2.pkg -target /
#     rm -rf aws AWSCLIV2.pkg
#     brew tap weaveworks/tap
#     brew install weaveworks/tap/eksctl
# fi

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

echo "#########################################################"
_logger "[+] 3. Installing kubectl"
echo "#########################################################"
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/${KERNEL_TYPE}/amd64/kubectl"
sudo mv kubectl /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl
kubectl version --client

_logger "[+] 4. Install helm-3"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

echo "#########################################################"
_logger "[+] 5. Installing [terraform 0.14.10](https://github.com/hashicorp/terraform)"
echo "#########################################################"
cd ~
version=0.14.10
# version=$(curl https://api.github.com/repos/hashicorp/terraform/releases/latest --silent | jq ".tag_name" -r)
# version=$(echo $version | sed 's/v//g') # get rid of 'v' from version number
echo "Installing Terraform $version."
url="https://releases.hashicorp.com/terraform/$version/terraform_$(echo $version)_${KERNEL_TYPE}_amd64.zip"
curl -L -o terraform_amd64.zip $url
unzip "terraform_amd64.zip"
chmod +x terraform
sudo mv terraform /usr/local/bin/
echo "Terraform $version installed."
rm "terraform_amd64.zip"
echo "Install terraform*.zip file cleaned up."

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
echo "[x] Verify k9s": $(k9s version --short)
