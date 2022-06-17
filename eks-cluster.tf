provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "remote" {
  backend = "s3"
  config = {
    bucket = "miax-state-files"
    key = "VPC/terraform.tfstate"
    region = "us-east-1"
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.21"
  subnets         = "${data.terraform_remote_state.remote.outputs.module_vpc3_private_subnets}"

  vpc_id = "${data.terraform_remote_state.remote.outputs.module_vpc3_vpc_id}"
  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      asg_desired_capacity          = 2
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

resource "aws_eks_node_group" "vericlear" {
  cluster_name    = var.cluster_name
  node_group_name = "vericlear"
  node_role_arn   = module.eks.worker_iam_role_arn
  subnet_ids      = "${data.terraform_remote_state.remote.outputs.module_vpc3_private_subnets}"


  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }
  update_config {
    max_unavailable = 2
  }
  tags = {
    Department = "Infrastructure"
    Name = "Vericlear_node"
  }
}

resource "aws_security_group_rule" "Openrule" {

  description       = "Allow cluster ingress access."
  protocol          = "-1"
  security_group_id = module.eks.worker_security_group_id
  cidr_blocks       = var.clusteringress_cidrs
  from_port         = 0
  to_port           = 0
  type              = "ingress"
}

resource "aws_security_group_rule" "NodeOpenrule" {

  description       = "Allow cluster ingress access for nodegroup."
  protocol          = "-1"
  security_group_id = module.eks.cluster_primary_security_group_id
  cidr_blocks       = var.clusteringress_cidrs
  from_port         = 0
  to_port           = 0
  type              = "ingress"
}
