#!/bin/bash
LOG_FILE=./error.log
# Redirect standard error to output
exec 2>$LOG_FILE
errtxt="please check $LOG_FILE for errors"
s="STEP"

installcdk(){
  echo "$s 3:installing cdk"       
  npm install cdk  
  echo "$s 3: NPM Dependencies installed"
}
installnpmdependencies(){  
  echo "$s 1:installing npm & cdk dependencies..."       
  npm install @aws-cdk/aws-eks cdk8s cdk8s-plus constructs
  npm i
  echo "$s 1: NPM Dependencies installed"
}

buildproject(){
  echo "$s 2:Building project..."
  npm run build
  echo "$s 2:Project build completed!"
}

cdkbootstrap(){
  echo "$s 4:Running CDK Bootstrap..."
  ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
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
  echo "$s 4:CDK Bootstrap completed!"
}

if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
else 
  echo 'Git Installed'
  GitVersion=$(git version | cut -d " " -f 3)
  echo $GitVersion
fi

if ! [ -x "$(command -v npm)" ]; then
  echo 'Error: npm is not installed.' >&2
  exit 1
else 
  echo 'npm Installed'
  NpmVersion=$(npm -v)
  echo "Version: $NpmVersion"
fi

if ! [ -x "$(command -v node)" ]; then
  echo 'Error: node is not installed.' >&2
  exit 1
else 
  echo 'node Installed'
  NodeVersion=$(node -v)
  echo "Version: $NodeVersion"
fi

if ! [ -x "$(command -v cdk)" ]; then
  echo 'Error: cdk is not installed.' >&2
  installcdk  
else 
  echo 'cdk Installed'
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