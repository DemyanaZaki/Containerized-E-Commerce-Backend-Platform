###create_vpc
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  lifecycle{
    prevent_destroy = true
  }
 
 

  tags = {
    Name = var.vpc_name
  }

}

###create_public_subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.Public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone= var.availability_zone

  tags = {
    Name = "public-subnet"
  }
}



###create_private_subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone= var.availability_zone

  tags = {
    Name = "private-subnet"
  }
}



###create_internet_GW

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.igw_name
  }
}

###create_nat_gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = var.nat_gw
  }

 
  depends_on = [aws_internet_gateway.gw]
}

###create_eip
resource "aws_eip" "eip" {
  domain   = "vpc"
  depends_on=[aws_internet_gateway.gw]
}




##create_route_table_for_public

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


  tags = {
    Name = "public_route_table"
  }
}


##create_route_table_for_private

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
  cidr_block     = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
}


  tags = {
    Name = "private_route_table"
  }
}

###Attach_route_table_with_private_subnet

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}



###Attach_route_table_with_public_subnet

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}







this my vpc code 
output "vpc_id" {
  value = aws_vpc.main.id
}


output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
} 
my output 
and this is my variables 
variable "vpc_cidr" {}
variable "vpc_name" {}

variable "Public_subnet_cidr" {}
variable "private_subnet_cidr" {}

variable "availability_zone" {}

variable "igw_name" {}
variable "nat_gw" {}



