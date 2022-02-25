#!/bin/bash
LOG_FILE=./error.log
# Redirect standard error to output
exec 2>$LOG_FILE
errtxt="please check $LOG_FILE for errors"
s="STEP"

installcdk(){
  echo "$s ⚙️ Installing cdk"       
  npm install -g cdk cdk8s-cli  
  echo "$s ⚙️ CDK & CDK8s installed"
}
installnpmdependencies(){  
  echo "$s ⚙️ Installing npm & cdk dependencies..."       
  npm i
  echo "$s ⚙️ NPM Dependencies installed"
}

buildproject(){
  echo "$s 🛠️ Building project >> CDK8s Compile + Synth ..."
  npm run build
  echo "$s 🛠️ Project build completed!"
}

cdkbootstrap(){
  echo "$s 🚀 Running CDK Bootstrap ..."
  if [ $(uname -s) == 'Darwin' ] ; then
    ACCOUNT=$(aws sts get-caller-identity | jq -r '.Account' | tr -d '\n')
  else
    ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
  fi
  REGION=$(aws configure get region)

  if [ -z "$ACCOUNT" ]; then 
    echo "Account is not configured"
    exit 1
  else 
    echo "Account used for bootstrap $ACCOUNT"
  fi
  if [ -z "$REGION" ]; then 
    echo "Region is not configured"
    exit 1
  else 
    echo "Region used for bootstrap $REGION"
  fi
  cdk bootstrap aws://$ACCOUNT/$REGION 
  echo "$s ⚡ CDK Deploy ..."
  cdk deploy --require-approval never
  echo "$s ✨ cdk destroy --require-approval never"
  echo "$s 💯 CDK Bootstrap & Deploy completed!"
}

if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
else 
  echo '✅ Git Installed'
  GitVersion=$(git version | cut -d " " -f 3)
  echo $GitVersion
fi

if ! [ -x "$(command -v npm)" ]; then
  echo 'Error: npm is not installed.' >&2
  exit 1
else 
  echo '✅ NPM Installed'
  NpmVersion=$(npm -v)
  echo "Version: $NpmVersion"
fi

if ! [ -x "$(command -v node)" ]; then
  echo 'Error: node is not installed.' >&2
  exit 1
else 
  echo '✅ Node Installed'
  NodeVersion=$(node -v)
  echo "Version: $NodeVersion"
fi

if ! [ -x "$(command -v cdk)" ]; then
  echo 'Error: cdk is not installed.' >&2
  installcdk  
else 
  echo '✅ CDK Installed'
  CdkVersion=$(cdk --version | cut -d " " -f 1)
  echo "Version: $CdkVersion"
fi

if [ -x "$(command -v npm)" ]; then
  installnpmdependencies
  buildproject
fi

if [ -x "$(command -v cdk)" ]; then  
  cdkbootstrap
fi