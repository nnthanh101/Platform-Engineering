# All-In-One Kubernetes tools (kubectl, helm, iam-authenticator, eksctl, kubeseal, etc)

Kubernetes docker images with necessary tools 

[![DockerHub Badge](http://dockeri.co/image/nnthanh101/k8s)](https://hub.docker.com/r/nnthanh101/k8s/)

### Installed tools

- [x] [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (latest minor versions: https://kubernetes.io/releases/)
- [x] [kustomize](https://github.com/kubernetes-sigs/kustomize) (latest release: https://github.com/kubernetes-sigs/kustomize/releases/latest)
- [x] [helm](https://github.com/helm/helm) (latest release: https://github.com/helm/helm/releases/latest)
- [x] [helm-diff](https://github.com/databus23/helm-diff) (latest commit)
- [ ] [helm-unittest](https://github.com/helm-unittest/helm-unittest) (latest commit)
- [ ] [helm-push](https://github.com/chartmuseum/helm-push) (latest commit)
- [x] [aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator) (latest version when run the build)
- [x] [eksctl](https://github.com/weaveworks/eksctl) (latest version when run the build)
- [x] [awscli v2](https://github.com/aws/aws-cli) (latest version when run the build)
- [ ] [kubeseal](https://github.com/bitnami-labs/sealed-secrets) (latest version when run the build)
- [ ] [krew](https://github.com/kubernetes-sigs/krew) (latest version when run the build)
- [ ] [vals](https://github.com/helmfile/vals) (latest version when run the build)
- [x] General utilities, including jq, yq, gettext (for envsubst), curl, ca-certificates, bash, git, python3
bash, curl, jq, yq, etc

### Docker image tags

https://hub.docker.com/r/nnthanh101/k8s/tags/

## Why we need it

Mostly it is used during CI/CD (continuous integration and continuous delivery) or as part of an automated build/deployment

### kubectl versions

You should check in [kubernetes versions](https://kubernetes.io/releases/), it lists the kubectl latest minor versions and used as image tags.

### Involve with developing and testing

If you want to build these images by yourself, please follow below commands.

```
export REBUILD=true
# comment the line in file "build.sh" to stop image push:  docker push ${image}:${tag}
bash ./build.sh
```

Second thinking, if you are adding a new tool, make sure it is supported in both `linux/amd64,linux/arm64` platforms

### [alpine-docker/k8s](https://github.com/alpine-docker/k8s)

* 1. **There is no `latest` tag for this image**
* 2. This image supports `linux/amd64,linux/arm64` platforms
