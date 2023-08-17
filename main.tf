# Configure the AWS Provider  20230802 Freeman For AWS & Terraform Test
provider "aws" {
    region = "eu-west-3"
}

# Create a genaral vpc by different environment such as dev
resource "aws_vpc" "FreemanTerraformLearn" {
  cidr_block = var.vpc_cidr_blocks
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

module "FreemanSubnet-1" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.FreemanTerraformLearn.id
  default_route_table_id = aws_vpc.FreemanTerraformLearn.default_route_table_id
}




# Create a security group by different environment such as dev-Security-Group
resource "aws_security_group" "FreemanTerraformSecurityGroup" {
  vpc_id = aws_vpc.FreemanTerraformLearn.id
  name = "FreemanTerraformSecurityGroup"

# Ingress for internal network communications by internal image or resources
  ingress  {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 


  # engress for out of international network communications. normally, no limitations of ipaddress
  egress  {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_prefix}-Security-Group"
  }
}

/* Create Data blocks are used to obtain data from external data sources for use in Terraform configurations. 
It allows to reference external data sources such as local files, remote servers, databases,
or other data storage services in the Terraform module. */

data "aws_ami" "latest-amazon-linux-image"{
   most_recent = true
   owners = ["amazon"]
   filter {
     name = "name"
     /* image value is copies by ami community list. 
       for example: amzn2-ami-hvm-2.0.20230221.0-arm64-gp2  "-*-"" means a dynamic distributed */
     values = ["amzn2-ami-hvm-*-arm64-gp2"]
   }
   filter {
    /* filter name is copies by ami community list. 
       for example: virtualization-type=hvm */
     name = "virtualization-type"
     values = ["hvm"]
   }
}



resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = "${file(var.public_key_location)}"
}

# Create instance 
resource "aws_instance" "FreemanTerraformInstance" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type
  /* Below options are optional due to aws will be used default vpc and others*/
  subnet_id = module.FreemanSubnet-1.subnet.id
  vpc_security_group_ids = [aws_security_group.FreemanTerraformSecurityGroup.id]
  availability_zone = var.avail_zone
  associate_public_ip_address = true

  # Important part : Keys!! must be create a key pair in EC2 view page
  key_name = aws_key_pair.ssh-key.key_name
  tags = {
    Name = "${var.env_prefix}-server"
  }

  #Create Docker image and start it.

  #user_data = file("entry-script.sh")

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = "${file(var.private_key_location)}"
  }
  /* provisioner "remote-exec" {
    inline = [
      # "#!/bin/bash",
      # "sudo yum update -y && sudo yum install -y docker",
      # "sudo systemctl start docker",
      # "sudo usermod -aG docker ec2-user",
      # "sudo docker run -p 8080:80 nginx"
    ]
  } */

}