#!/bin/bash
set -euxo pipefail

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

function _logger() {
    echo -e "$(date) ${YELLOW}[*] $@ ${NC}"
}

KERNEL_TYPE=linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux OS"
    DISTRO_ID=$(lsb_release -si)
    if [[ "$DISTRO_ID" == "Ubuntu" ]]; then
        echo "Install with apt"
        sudo apt-get install -y apache2-utils jq gettext bash-completion
    elif [[ "$DISTRO_ID" == "AmazonLinux"* ]]; then
        echo "Install with yum"
        sudo yum install -y jq gettext bash-completion
    else
        echo "error can't install package"
        exit 1;
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install jq wget
    KERNEL_TYPE=darwin
else
    echo "Unsupport platform: $OSTYPE"
    exit 1
fi

# Install latest awscli (version 2)
if [[ "$KERNEL_TYPE" == "linux" ]]; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install --update
    rm -rf awscliv2.zip aws
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    sudo mv /tmp/eksctl /usr/local/bin
else
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg ./AWSCLIV2.pkg -target /
    rm -rf aws AWSCLIV2.pkg
    brew tap weaveworks/tap
    brew install weaveworks/tap/eksctl
fi

# Install terraform 0.15.0
cd ~
version=0.15.0
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

# Install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh
