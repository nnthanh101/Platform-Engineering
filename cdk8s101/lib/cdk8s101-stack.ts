import * as cdk from '@aws-cdk/core';
import * as eks from '@aws-cdk/aws-eks';
import * as ec2 from '@aws-cdk/aws-ec2';
import * as iam from '@aws-cdk/aws-iam';

import * as cdk8s from 'cdk8s'
import { MyChart } from '../main';

// const KEYPAIR_NAME = 'cdk8s-keypair';
const PROJECT_NAME = 'CDK8s'

export class Cdk8S101Stack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // The code that defines your stack goes here

    // const keyname = new cdk.CfnParameter(this, 'KeyName', {
    //   type: 'String',
    //   default: KEYPAIR_NAME
    // })

    /** Create a new VPC with single NAT Gateway */
    const vpc = new ec2.Vpc(this, PROJECT_NAME.concat('VPC'), {
      cidr: '10.0.0.0/22',
      natGateways: 1
    });

    const clusterAdmin = new iam.Role(this, 'AdminRole', {
      assumedBy: new iam.AccountRootPrincipal()
    });


    /** The code that defines your stack goes here */
    const eksCluster = new eks.Cluster(this, PROJECT_NAME.concat('Cluster'), {
      version: eks.KubernetesVersion.V1_21,
      clusterName: PROJECT_NAME.concat('Cluster'),
      vpc: vpc,
      defaultCapacity: 1,
      mastersRole: clusterAdmin,
      outputClusterName: true
    })

    /**
     * Code to add pods on EKS cluster. All containers are defined in MyChart
     */
    eksCluster.addCdk8sChart('my-chart', new MyChart(new cdk8s.App(), 'MyChart'));

    new cdk.CfnOutput(this, 'EksClusterName', {
      value: eksCluster.clusterName,
      exportName: 'EksClusterName'
    })

  }
}
