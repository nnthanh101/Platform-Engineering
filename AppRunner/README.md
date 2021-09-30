# Build & Deploy Applications to `AWS App Runner` Serverless Container using `Terraform`



## Introduction

<details><summary>The purpose of this lab is to enable Engineers to get some hands-on experience building CI/CD Pipeline for Serverless Container workloads.</summary>

* It consists of 2 lab modules, each designed to demonstrate a CI/CD pattern. You will be using **GitHub Action** and AWS services like **AWS App Runner**, **Amazon RDS**, **AWS CodePipeline**, **AWS CodeCommit**, and **AWS CodeBuild**.
* **[AWS App Runner](https://aws.amazon.com/apprunner)** leverages AWS best practices and technologies for deploying and running containerized web applications at scale, which leads to a drastic reduction in your time to market for new applications and features. **App Runner** runs on top of **AWS ECS & Fargate**, a lot easier to get into, and cost estimation for App Runner is far simpler - AWS charges a fixed CPU and Memory fee per second.

</details>
 

## TF1. AppRunner using Github Action & Private ECR ⚡

![Private ECR](README/images/private-ecr-diagram.svg)

<details><summary>AWS AppRunner with Terraform</summary>

There are 3 examples inside the `src` folder:

* `github`: deploy an AppRunner service using code directly from a GitHub repository
* `public-ecr`: deploy an AppRunner service using a container image from a public ECR registry.
* `private-ecr`: deploy an AppRunner service using a container image from a private ECR registry.

To run a example, `cd` into that folder and run `./run.sh` to see help message.

Run `cp some.env.example some.env` to generate an initial configurations for scripts.
</details>

## TF2. AppRunner using AWS CodePipeline, Amazon RDS and Terraform

Build and Deploy Spring Petclinic Application to AWS App Runner using AWS CodePipeline, Amazon RDS and Terraform 

![Architecture](README/images/AppRunner-Architecture.png)

<details><summary>Background - The Spring PetClinic application</summary>

The Spring PetClinic application is designed to show how the Java/Spring application framework can be used to build simple, but powerful database-oriented applications. It uses AWS RDS (MySQL) at the backend and it will demonstrate the use of Spring's core functionality. The Spring Framework is a collection of small, well-focused, loosely coupled Java frameworks that can be used independently or collectively to build industrial strength applications of many different types. 

</details>
