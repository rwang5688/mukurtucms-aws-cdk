import * as cdk from "aws-cdk-lib";
import * as ec2 from "aws-cdk-lib/aws-ec2";
import * as rds from "aws-cdk-lib/aws-rds";
import * as secretsmanager from "aws-cdk-lib/aws-secretsmanager";
import * as iam from "aws-cdk-lib/aws-iam";
import {readFileSync} from 'fs';
import { Construct } from 'constructs';

export class MukurtucmsAwsCdkStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
    
    // Parameter: Key Pair
    const ec2KeyPairParam = new cdk.CfnParameter(this, "ec2KeyPair", {
      type: "String",
      default: "ec2-key-pair",
      description: "Key pair for the EC2 instance.",
    });
    const ec2KeyPair = ec2KeyPairParam.valueAsString;

    // Create VPC
    const vpc = new ec2.Vpc(this, "mukurtucms-vpc", {
      cidr: "10.0.0.0/16",
      maxAzs: 2,
      subnetConfiguration: [
        {
          name: "mukurtucms-public-",
          subnetType: ec2.SubnetType.PUBLIC,
          cidrMask: 24,
          mapPublicIpOnLaunch: true,
        },
      ],
    });

    // Create RDS Secret
    const rdsSecret = new secretsmanager.Secret(this, "mukurtucms-rds-secret", {
      secretName: "mukurtucms-rds-secret",
      generateSecretString: {
        secretStringTemplate: JSON.stringify({ username: "admin" }),
        generateStringKey: "password",
        excludePunctuation: true,
      },
      removalPolicy: cdk.RemovalPolicy.DESTROY,
    });

    // Create RDS Instance Security Group
    const rdsInstanceSG = new ec2.SecurityGroup(this, "mukurtucms-rds-sg", {
      vpc: vpc,
      allowAllOutbound: true,
      description: "Mukurtu CMS RDS Instance security group",
    });

    // Create RDS Instance (m6i.large, 2 vPUCs, 8 GiB RAM, io1, 100 GiB, 1500 IOPS)
    const rdsInstance = new rds.DatabaseInstance(this, "mukurtucms-rds-instance", {
      engine: rds.DatabaseInstanceEngine.mysql({
        version: rds.MysqlEngineVersion.VER_8_0_30,
      }),
      vpc: vpc,
      vpcSubnets: { subnetType: ec2.SubnetType.PUBLIC },
      credentials: rds.Credentials.fromSecret(rdsSecret),
      removalPolicy: cdk.RemovalPolicy.DESTROY,
      securityGroups: [rdsInstanceSG],
      storageEncrypted: true,
      instanceType: ec2.InstanceType.of(
        ec2.InstanceClass.M6I,
        ec2.InstanceSize.LARGE
      ),
      publiclyAccessible: false,
      allocatedStorage: 100,
      storageType: rds.StorageType.IO1,
      iops: 1500,
      instanceIdentifier: "mukurtucms-rds-instance",
    });

    // Create EC2 Instance Security Group
    const ec2InstanceSG = new ec2.SecurityGroup(this, "mukurtucms-ec2-sg", {
      vpc: vpc,
      allowAllOutbound: true,
      description: "Mukurtu CMS EC2 Instance security group",
    });

    ec2InstanceSG.addIngressRule(
      ec2.Peer.anyIpv4(),
      ec2.Port.tcp(22),
      'allow SSH access from anywhere',
    );

    ec2InstanceSG.addIngressRule(
      ec2.Peer.anyIpv4(),
      ec2.Port.tcp(80),
      'allow HTTP traffic from anywhere',
    );

    ec2InstanceSG.addIngressRule(
      ec2.Peer.anyIpv4(),
      ec2.Port.tcp(443),
      'allow HTTPS traffic from anywhere',
    );

    // Allow EC2 Instance SG to communicate to RDS Instance SG
    rdsInstanceSG.connections.allowFrom(
      new ec2.Connections({ securityGroups: [ec2InstanceSG] }),
      ec2.Port.tcp(3306),
      "EC2 Instance to RDS Instance (MySQL)"
    );

    // Create a Role for the EC2 Instance (w/ AmazonS3ReadOnlyAccess as sample policy)
    const ec2InstanceRole = new iam.Role(this, "mukurtucms-ec2-role", {
      assumedBy: new iam.ServicePrincipal('ec2.amazonaws.com'),
      managedPolicies: [
        iam.ManagedPolicy.fromAwsManagedPolicyName('AmazonS3ReadOnlyAccess'),
      ],
    });

    // Create the EC2 Instance (m6i.large, 2 vCPUs, 8 GiB RAM, )
    const ec2Instance = new ec2.Instance(this, "mukurtucms-ec2-instance", {
      vpc,
      vpcSubnets: {
        subnetType: ec2.SubnetType.PUBLIC,
      },
      role: ec2InstanceRole,
      securityGroup: ec2InstanceSG,
      instanceType: ec2.InstanceType.of(
        ec2.InstanceClass.M6I,
        ec2.InstanceSize.LARGE,
      ),
      machineImage: new ec2.AmazonLinuxImage({
        generation: ec2.AmazonLinuxGeneration.AMAZON_LINUX_2,
      }),
      keyName: ec2KeyPair,
    });

    // Load contents of script
    const userDataScript = readFileSync('./lib/user-data.sh', 'utf8');
    // Add the User Data script to the Instance
    ec2Instance.addUserData(userDataScript);
  }
}
