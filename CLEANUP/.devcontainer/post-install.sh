#!/usr/bin/env bash

clear
printf "\e[0;32mAWS Terraform Dev Container: $(basename $PWD)\e[0m\n"

devcontainer-info

echo "[x] Verify Git client":        $(git --version)
echo "[x] Verify jq":                $(jq   --version)
echo "[x] Verify make":              $(make -v)

echo "[x] Verify AWS CLI version 2": $(aws --version)
echo "[x] Verify NVM":               $(nvm --version)
echo "[x] Verify Node.js":           $(node --version)
echo "[x] Verify yarn":              $(yarn --version)

echo "[x] Verify Python":            $(python -V)
echo "[x] Verify Python3":           $(python3 -V)
echo "[x] Verify Pip3":              $(pip3 -V)
echo "[x] Verify Pip":               $(pip -V)

echo "[x] Verify minikube":          $(minikube version)
echo "[x] Verify kubectl":           $(kubectl version --client)
echo "[x] Verify helm3":             $(helm version --short)
echo "[x] Verify terraform":         $(terraform -version)
echo "[x] Verify terraform-docs":    $(terraform-docs -v)
echo "[x] Verify tfsec":             $(tfsec -v)
echo "[x] Verify tflint":            $(tflint -v)
echo "[x] Verify terragrunt":        $(terragrunt -v)
echo "[x] Verify sentinel":          $(sentinel version)
echo "[x] Verify jupyter lab":       $(jupyter lab --version)
echo "[x] Verify jupyter lab list":  $(jupyter lab list)

echo "[-] Verify CDK":               $(cdk --version)
echo "[-] Verify eksctl":            $(eksctl version)
echo "[-] Verify k9s":               $(k9s version --short)

echo "[x] Verify ngrok":             $(ngrok --version)

tree -a | grep Dockerfile -C 1

# pip install --upgrade pip
pip install ipykernel ipywidgets && if [ -f requirements.txt* ]; then pip install -r requirements.txt; else pip install pandas numpy scipy statsmodels matplotlib seaborn plotly scikit-learn; fi

echo "Minikube ..."
cd devcontainer/minikube
./minikube.sh

echo "Running adminer Database management ..."
# docker run -p 8080:8080 -e ADMINER_DEFAULT_SERVER=postgre adminer