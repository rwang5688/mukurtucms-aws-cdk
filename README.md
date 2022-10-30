# AWS Infrastructure for Mukurtu CMS

This CDK is used to generate the CloudFormation template for an AWS infrastructure for running [Mukurtu CMS 3.0.3](https://github.com/MukurtuCMS/mukurtucms).

## Description
This CDK is used to generate the CloudFormation template for an AWS infrastructure for running [Mukurtu CMS 3.0.3](https://github.com/MukurtuCMS/mukurtucms).

We implement a CDK app with an instance of a stack (`MukurtucmsAwsCdkStack`).

The `cdk.json` file tells the CDK Toolkit how to execute your app.

## Useful commands

* `npm run build`   compile typescript to js
* `npm run watch`   watch for changes and compile
* `npm run test`    perform the jest unit tests
* `cdk deploy`      deploy this stack to your default AWS account/region
* `cdk diff`        compare deployed stack with current state
* `cdk synth`       emits the synthesized CloudFormation template
