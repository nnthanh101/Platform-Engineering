# Private EKS for Windows & Linux workloads with Terraform

* ✅ Provisions a private EKS cluster in a private VPC using Terraform, and deploys Windows and Linux nodes into the cluster. 
* ✅ Using VPC peering, a bastion host in a public VPC connects to the private VPC in order to access EKS cluster in the private VPC. The public VPC and bastion hosts are also part of this repository.Solution Architecture:

![Architecture](./README/images/Private-EKS-architecture.jpg)


<details>
  <summary>Prerequisites: https://terraform.job4u.io/en/prerequisites/cloud9-bootstrap.html</summary>

  - [x] [AWS Account](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
  - [x] `cloud9-tools-init.sh`: 
    - [x] [Terraform](https://www.terraform.io/downloads.html)
    - [x]  kubectl
    - [x]  k9s
  - [x] `init-state.sh`:
    - [x] S3 bucket to save the state.
    - [x] DynamoDB table for the statelock with partition key "LockID" of type String.
  - [ ] Create an EC2 SSH key in your AWS account if there is none existing by following this documentation: [Create a key pair using Amazon EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair)
    - SSH into the Linux node. 
    
      ```
      $ ssh ec2-user@<out_bastion_public_ip> -i <location_of_private_key>
      ```
  
</details>


### [1. Initial for Terraform State](https://terraform.job4u.io/en/private-eks/init-tf.html)

<details>
  <summary>workflows/1-tf-init-state.yml</summary>
  
  * [x] export PROJECT_ID=academy4u
  * [ ] [S3 Backend](https://www.terraform.io/language/settings/backends/s3): ${PROJECT_ID}-s3-state
  * [ ] DynamoDB: --table-name ${PROJECT_ID}-tf-lock --key-schema AttributeName=LockID >> Amazon DynamoDB table with partition key *LockID* of type String in your AWS account. 
  
</details>


### [2. Setting up the VPC Networking](https://terraform.job4u.io/en/private-eks/vpc-networking.html)

> This performs the deployment of the VPC including the setup of the bastion host in a separate VPC.

<details>
  <summary>workflows/2-vpc-private.yml</summary>
  
  > Modify the `bucket` and `dynamodb_table` that are used by Terraform [modules/network](./modules/network/main.tf)

  ````
  terraform {network
    backend "s3" {
      bucket         = "academy4u-s3-state"
      key            = "network.tfstate"
      region         = "ap-southeast-1"
      dynamodb_table = "academy4u-tf-lock"
    }
  }
  ````
  
</details>

<details>
  <summary>Open a command-line and move into the folder network and execute the deployement with Terraform:</summary>
  
   ````bash
   |-- modules 
   |   |-- network
   |   |   |-- main.tf
   |   |   |-- main-input.tfvars
   ````

   ```
   $ cd vpc-private-eks
   $ terraform init
   $ terraform apply -var-file main-input.tfvars
   ```  
  
</details>

> ✍️ Note down the output of `out_bastion_public_ip`


### [3. EKS Cluster setup](https://terraform.job4u.io/en/private-eks/eks-cluster.html)

> Provisioning the EKS cluster and the NodeGroups for Windows and Linux.

<details>
  <summary>workflows/3-private-eks.yml</summary>
  
  1. Replace the backed configuration in the [modules/private-eks-cluster/main.tf](./modules/private-eks-cluster/main.tf) with the same S3 bucket used for the network setup and DynamoDB table in your AWS account. 
     Add the correct backend configuration for *terraform_remote_state.network* as well.

     ````
     // Modify the bucket and dynamoDB table that are used by Terraform
     terraform {
       backend "s3" {
         bucket         = "academy4u-s3-state"
         key            = "private-eks.tfstate"
         region         = "ap-southeast-1"
         dynamodb_table = "academy4u-tf-lock"
       }
     }

     data terraform_remote_state "network" {
         backend = "s3"
         config = {
             bucket = "academy4u-s3-state"
             key = "network.tfstate"
             region = "ap-southeast-1"
          }
     }
     ````

  2. If you are using a federated role to access the AWS console, then replace the role ARN in [additional_roles_aws_auth.yaml](./yaml-templates/additional_roles_aws_auth.yaml) with the role that gets federated to allow access to the EKS cluster from the AWS console for you.

  3. Deploy the EKS cluster with the following commands from the root folder of the solution:

     ````bash
     |-- private-eks-cluster
     |   |-- main.tf
     |   |-- main-input.tfvars
     ````

  ```bash
  $ terraform init
  $ terraform apply -var-file main-input.tfvars
  ```

  4. The Windows nodes can take a few minutes until they are successfully bootstrapped and connected to the cluster.
  
  5. Validate deployment >> After the deployment is done, you can configure the local kubectl on the bastion host to connect to the EKS cluster.

  ```bash
  $ aws eks update-kubeconfig --name academy4u-cluster --region ap-southeast-1
  $ kubectl get nodes
  ```
  
  * [ ] Make sure to execute the Terraform script from inside the bastion host as otherwise Terraform will not be able to connect to the EKS cluster as the private endpoint will only be accessible from within the private VPC itself or a peered VPC. 

</details>



### Cleanup

<details>
  <summary>Cleanup >> EKS Cluster</summary>

  Execute the following inside of the root path of the repository inside the bastion host to clean-up the EKS cluster as well as the worker nodes:

  ````bash
  |-- private-eks-cluster
  |   |-- main.tf
  |   |-- main-input.tfvars
  ````

  ```bash
  $ terraform destroy -var-file main-input.tfvars
  ```

</details>

<details>
  <summary>Cleanup >> Bastion Host & VPCs</summary>

  Execute the same Terraform command again from your local workstation inside the network directory to clean-up the bastion host and both VPCs:

  ````bash
  |-- modules
  |   |-- network
  |   |   |-- main.tf
  |   |   |-- main-input.tfvars
  ````

  ```bash
  $ terraform destroy -var-file main-input.tfvars
  ```  

</details>

<details>
  <summary>Parameters in main-input.tfvars</summary>

  The repository provides the following defaults for the setup:

  - region = "ap-southeast-1"
  - VPC
    - azs_private = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
    - private_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
    - vpc_private_cidr = "10.10.0.0/16"
    - vpc_public_cidr = "10.20.0.0/16"
    - azs_public = ["ap-southeast-1a"]
    - public_subnets = ["10.20.1.0/24"]

  - EKS cluster
    - eks_cluster_name = "academy4u-cluster"
    - eks_cluster_version = "1.21"
  - Linux nodegroup
    - lin_desired_size = "2"
    - lin_max_size = "2"
    - lin_min_size = "2"
    - lin_instance_type = "t3.medium"

  - Windows nodegroup
    - win_desired_size = "2"
    - win_max_size = "2"
    - win_min_size = "2"
    - win_instance_type = "t3.xlarge"

</details>
