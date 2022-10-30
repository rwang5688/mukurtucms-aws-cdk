#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import { MukurtucmsAwsCdkStack } from '../lib/mukurtucms-aws-cdk-stack';

const app = new cdk.App();
new MukurtucmsAwsCdkStack(app, 'MukurtucmsAwsCdkStack');
