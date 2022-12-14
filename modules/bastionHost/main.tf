provider "aws" {
  region = "us-east-1"
}
# Use remote state to retrieve the data
data "terraform_remote_state" "network" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = var.bucket_name                        // Bucket from where to GET Terraform State
    key    = "${var.env}-network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                            // Region where bucket created
  }
}
data "terraform_remote_state" "security_group" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = var.bucket_name                               // Bucket from where to GET Terraform State
    key    = "${var.env}-security-group/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                                   // Region where bucket created
  }
}

# Local variables
locals {
  default_tags = merge(
    var.default_tags,
    { "Env" = var.env }
  )
  name_prefix = "${var.prefix}-${var.env}"
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  vpc_security_group_ids      = [data.terraform_remote_state.security_group.outputs.bastion_sg_id]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
  key_name = var.linux_key_ec2
  tags = {
    Name = "${local.name_prefix}-bastionhost"
  }
}
# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
