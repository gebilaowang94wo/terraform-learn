# Configure the AWS Provider  20230802 Freeman For AWS & Terraform Test
provider "aws" {
    region = "eu-west-3"
}
variable "cidr_block_FreemanAWSTest" {
  description = "Create cidr block for aws_vpc of FreemanAWSTest"
}

variable "cidr_block_FreemanAWSTest-subnet-1" {
  description = "Create cidr block for FreemanAWSTest-subnet-1"
  
}
variable "cidr_block_FreemanAWSTest-subnet-2" {
  description = "Create cidr block for FreemanAWSTest-subnet-2"
  
}
# Create aws vpc and IP range
resource "aws_vpc" "FreemanAWSTest" {
  cidr_block = var.cidr_block_FreemanAWSTest
  tags = {
    Name: "FreemanAWSTest-Dev"
    vpc_env:"Dev"
  }
}

# Create subnet 1
resource "aws_subnet" "FreemanAWSTest-subnet-1" {
  vpc_id = aws_vpc.FreemanAWSTest.id
  cidr_block = var.cidr_block_FreemanAWSTest-subnet-1
  availability_zone = "eu-west-3a"
  tags = {
    Name: "FreemanAWSTest-subnet-1"
  }
}

# Data query from existed IP address range


# Create subnet 2
resource "aws_subnet" "FreemanAWSTest-subnet-2" {
  vpc_id = aws_vpc.FreemanAWSTest.id
  cidr_block = var.cidr_block_FreemanAWSTest-subnet-2
  availability_zone = "eu-west-3a"
  tags = {
    Name: "FreemanAWSTest-subnet-2"
  }
}

output "dev-vpc-id" {
  value = aws_vpc.FreemanAWSTest.id
}
output "aws_subnet-id-1" {
  value = aws_subnet.FreemanAWSTest-subnet-1
}
output "aws_subnet-id-2" {
  value = aws_subnet.FreemanAWSTest-subnet-2
}