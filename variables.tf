# Setup variable for all required resources
variable vpc_cidr_blocks {}
# Define subnet cidr block
variable subnet_cidr_block{}
# Define availability zones
variable avail_zone {}
# Define environments such as dev uat prod
variable env_prefix {}
# Define IP address range
variable ip_address{}
# Define Instance types such as 
variable "instance_type" {}
# Define Public key location
variable "public_key_location" {}
# Define Private key locateion
variable "private_key_location" {}
