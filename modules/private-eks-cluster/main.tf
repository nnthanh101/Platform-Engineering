terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.72.0"
    }
  }
}

provider "aws" {
  region = var.region
}

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
    config  = {
        bucket = "academy4u-s3-state"
        key    = "network.tfstate"
        region = "ap-southeast-1"
     }
}

module "cluster" {
    source = "./eks.cluster"
    region = var.region
    eks_cluster_name = var.eks_cluster_name
    eks_cluster_version = var.eks_cluster_version 
    private_subnet_ids = data.terraform_remote_state.network.outputs.out_private_vpc.private_subnets
    vpc_id = data.terraform_remote_state.network.outputs.out_private_vpc.vpc_id
    bastion_host_SG_id = data.terraform_remote_state.network.outputs.out_bastion_host_security_group_id
    lin_desired_size = var.lin_desired_size
    lin_max_size = var.lin_max_size
    lin_min_size = var.lin_min_size
    lin_instance_type = var.lin_instance_type
    win_desired_size = var.win_desired_size
    win_max_size = var.win_max_size
    win_min_size = var.win_min_size
    win_instance_type = var.win_instance_type
    node_host_key_name = var.node_host_key_name
}


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