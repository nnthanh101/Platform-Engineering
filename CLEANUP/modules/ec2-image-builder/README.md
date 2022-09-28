# AWS EC2 Image Builder Pipeline

Terraform Module that configures AWS EC2 Image Builder Pipeline and components


## Structure

- ./ec2-image-builder = Used to provision [AWS EC2 Image Builde](https://aws.amazon.com/image-builder/)


## Components
- EC2 Image Builder Pipeline
- EC2 Image Builder Distribution Configuration used to define desired AWS Regions and Accounts as destinations for newly created AMI
- EC2 Image Builder IAM Role and Policies
- EC2 Image Builder EC2 Security Group used by the EC2 AMI instance
- EC2 Image Builder Infrastructure Configuration for AMI setup
- EC2 Image Builder Component defining the platform and version
- EC2 Image Builder Recipe for Windows OS

## Pre-requisites
* Optimization of the Terraform templates to reflect the desired deployment environment structure, naming standards, variables, outputs, references, etc.
* Review of the defined IAM Roles
* Updates of the variables and relevant values to reflect the desired deployment environment
* Customer managed Windows OS with desired base application AMIs which will be distributed to the desired AWS Account and Regions through AWS EC2 Image Builder (or similar)
