# The GitOps Platform for Data Analytics on Kubernetes 🚀

🎯 The GitOps Platform for Data Analytics utilizes Kubernetes (K8s) and HashiCorp's Terraform Infrastructure as Code (IaC) on the AWS Cloud 🌥️, offering speed, scalability, agility, and cost efficiency. ⚡

## Build, Scale, and Optimize Data & AI/ML Platforms on K8s

### 🏗️ Architecture
The diagram below showcases the wide array of open-source data tools, Kubernetes operators, and frameworks supported by DoK8s. It also highlights the seamless integration of Data Analytics managed services with the powerful capabilities of DoK8s open-source tools: reusable, composable, configurable.

<img width="800" alt="image" src="README/images/DoK8s-Architecture.png">

### 🌟 Features
Data on K8s (DoK8s) solution is categorized into the following focus areas.

* 🎯 [Data Analytics](docs/blueprints/data-analytics) on K8s
* 🎯 [AI/ML](docs/blueprints/ai-ml) on K8s
* 🎯 [Streaming Platforms](docs/blueprints/streaming-platforms) on K8s
* 🎯 [Scheduler Workflow Platforms](docs/blueprints/job-schedulers) on K8s
* 🎯 [Distributed Databases & Query Engine](docs/blueprints/distributed-databases) on K8s

## 🏃‍♀️ Deliverables

* [x] 🚀 Reproducible Local Development with Dev Containers: VSCode, K8s, TF, Python/R
* [ ] 🚀 [JupyterHub on EKS](docs/blueprints/ai-ml/jupyterhub) 👈 This blueprint deploys a self-managed JupyterHub on EKS with Amazon Cognito authentication.
* [ ] 🚀 [Spark Operator with Apache YuniKorn on EKS](docs/blueprints/data-analytics/spark-operator-yunikorn) 👈 This blueprint deploys EKS cluster and uses Spark Operator and Apache YuniKorn for running self-managed Spark jobs
* [ ] 🚀 [Self-managed Airflow on EKS](docs/blueprints/job-schedulers/self-managed-airflow) 👈 This blueprint sets up a self-managed Apache Airflow on an Amazon EKS cluster, following best practices.
* [ ] 🚀 [Argo Workflows on EKS](docs/blueprints/job-schedulers/argo-workflows-eks) 👈 This blueprint sets up a self-managed Argo Workflow on an Amazon EKS cluster, following best practices.
* [ ] 🚀 [Kafka on EKS](docs/blueprints/streaming-platforms/kafka) 👈 This blueprint deploys a self-managed Kafka on EKS using the popular Strimzi Kafka operator.

Built with ❤️ at AWS 🌥️ K8s 🌟 Terraform 🚀.
