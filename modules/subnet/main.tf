# Create a subnet by different environment such as dev-subnet-1
resource "aws_subnet" "FreemanSubnet-1" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name: "${var.env_prefix}-subnet-1"
  }
}

# Create a route table by different environment such as dev-route-table
resource "aws_route_table" "FreemanTerraformRouteTable" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.FreemanTerraformInternetGateway.id
  }
  tags = {
    Name : "${var.env_prefix}-route_table"
  }
}

# Create a gateway by different environment such as dev-Internet-Gateway
resource "aws_internet_gateway" "FreemanTerraformInternetGateway" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.env_prefix}-Internet-Gateway"
  }
}
