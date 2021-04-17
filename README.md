<p align="center"> 
<img src="README/eks-scenario.png">
</p>

This guide describes the architecture and implementation of production-ready **Amazon EKS (Elastic Kubernetes Service)** using **Hashicorp Terraform** in multiple *AWS accounts* with a unique *Terraform state*, including 

* [x] 2. **AWS Infrastructure**
    * [x] 2.1. New **Amazon Virtual Public Cloud** (**VPC**) or specified **Amazon VPC** in same or different **AWS accounts**.
        * [x] 2.1.1. Standard VPC:
        * [ ] 2.1.2. Private VPC:
        * [ ] 2.1.3. Advanced VPC: 
    * [ ] 2.2.1. [VPC Interface endpoints](https://aws.amazon.com/premiumsupport/knowledge-center/ec2-systems-manager-vpc-endpoints/): the Security-Group should allow “443” INGRESS for your Worker-Node Security-Group. 
        * [ ] ec2.$AWS_REGION.amazonaws.com
        * [ ] dkr.ecr.$AWS_REGION.amazonaws.com
        * [ ] api.ecr.$AWS_REGION.amazonaws.com
    * [ ] 2.2.2. VPC Gateway endpoint: VPC Route-Table associate with Worker-Node Subnets.
        * [ ] s3.$AWS_REGION.amazonaws.com 
    * [x] 2.4. EFS 
    * [ ] 2.5. [AWS EC2 Image Builder Pipeline](https://aws.amazon.com/image-builder/)
* [ ] 3. [RBAC for Devlopers and Administrators](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html): predefined roles and attach corresponding policies with the roles.
* [ ] 4. VPC-Peering
* [ ] 5. Provisioning **Amazon EKS cluster**: uses configurable **Terraform modules** with related AWS resources spanned across multiple **AWS accounts**.
    * [ ] [Amazon EKS cluster endpoint access control](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html#modify-endpoint-access)
        * [ ] Public Amazon EKS cluster exposes public endpoints of other required services  for communication.  
        * [ ] Provision EKS in a fully private VPC with worker nodes in private subnets. Private EKS cluster is not exposed to internet directly.
    * Worker nodes: Self-Managed Nodes, Managed NodeGroups, or AWS Fargate.
    * EC2 Spot Instance
    * NameSpaces will be enabled to support multi-tenancy.
    * Associating multiple Auto Scaling Groups with different instance types enabled with EC2 launch templates
    * Each Auto Scaling Groups has specific tags that can be used to schedule pods via label selectors.
    * Setup  Horizontal Pod Autoscaler (HPA) to automatically scale the number of pods running on K8s.
* [ ] Uses **Helm** provider is to deploy software packages in Kubernetes cluster
    * [ ] Autoscaling of nodes (automatic node replacement, Scale in/out, tagging inheritance)
    * [ ] HPA (Horizontal Pod Autoscaling) , It shall have configurable options for expanding resource quotas, pod security policies
    * [ ] Service Discovery and Service Mesh capability 
    * [ ] Authentication and Authorization: 
    * [ ] **Ingress** traffic type: HTTP, gRPC, WebSocket: `Traefik`, ...
* [ ] **Logging & Monitoring** of applications and system pods using **Amazon CloudWatch** ( `aws-for-fluent-bit` helm module), Newrelic? ...
    * [ ] FluentBit-> Cloudwatch -> ElasticSearch Cluster 
* [ ] **CI/CD Pipeline** be enabled to handle configuration file separately for separate environments; support configurable cluster deployments forDev/Test, Staging, Prod environments in different AWS account from same code base with minimum configuration changes.
