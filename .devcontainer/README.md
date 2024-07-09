# DevContainer Configuration

[DevContainer](https://code.visualstudio.com/docs/devcontainers/containers) is a VSCode feature that allows developers to share a common workspace definition, by leveraging Docker to run the workspace, and using VSCode Remote Development extension, you can make sure the developer experience is the same across different computers

## Benefits

- Developers only need to have VSCode and Docker installed
- All dependencies necessary to work in the repository are contained in the docker image
- Makes it easier for new developers to start contributing to the project
- No extra setup required



Simplified DevEx in bare-metal:

- 3x Clusters (Dev,QA,Pre-Prod)

- Stack:

- Kubernetes (vanilla kubeadm installation) LB (Haproxy) + 3x control-planes + N workers

- ArgoCD + Ingress + Monitoring/Logging stack (Grafana, Prometheus, Opensearch)

- Github, Bitbucket or similar.

Basically, you promote your app from Dev -> Prod deploying you code in Github and ArgoCD sync does the rest.

