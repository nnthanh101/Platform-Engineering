#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { Cdk8sStack } from '../lib/task1-stack';

const app = new cdk.App();
new Cdk8sStack(app, 'Cdk8sStack', {});
