# Configure the AWS Provider  20230802 Freeman For AWS & Terraform Test
provider "aws" {
    region = "eu-west-3"
}


# Setup variable for all required resources
variable vpc_cidr_blocks {}
variable subnet_cidr_blocks {}
variable availz_zone {}
variable env_prefix {}
variable ip_address{}

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

resource "aws_route_table" "FreemanTerraformRouteTable" {
  vpc_id = aws_vpc.FreemanTerraformLearn.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.FreemanTerraformInternetGateway.id
  }
  tags = {
    Name : "${var.env_prefix}-route_table"
  }
}

resource "aws_internet_gateway" "FreemanTerraformInternetGateway" {
  vpc_id = aws_vpc.FreemanTerraformLearn.id
  tags = {
    Name = "${var.env_prefix}-Internet-Gateway"
  }
}

resource "aws_security_group" "FreemanTerraformSecurityGroup" {
  vpc_id = aws_vpc.FreemanTerraformLearn.id
  name = "FreemanTerraformSecurityGroup"

  ingress  {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.ip_address]
  } 

  ingress  {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress  {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_prefix}-Security-Group"
  }
}