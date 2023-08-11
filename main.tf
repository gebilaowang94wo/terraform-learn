# Configure the AWS Provider  20230802 Freeman For AWS & Terraform Test
provider "aws" {
    region = "eu-west-3"
}


# Setup variable for all required resources
variable vpc_cidr_blocks {}
variable subnet_cidr_blocks {}
variable availz_zone {}
variable env_prefix {}

resource "aws_vpc" "FreemanTerraformLearn" {
  cidr_block = var.vpc_cidr_blocks
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "FreemanSubnet-1" {
  vpc_id = aws_vpc.FreemanTerraformLearn.id
  cidr_block = var.subnet_cidr_blocks
  availability_zone = var.availz_zone
  tags = {
    Name: "${var.env_prefix}-subnet-1"
  }
}