# VPC
resource "aws_vpc" "app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "AppVPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "AppInternetGateway"
  }
}

# Subnets
resource "aws_subnet" "app_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "AppSubnet-${count.index}"
  }
}

# Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "PublicRouteTable"
  }
}

# Route to Internet Gateway
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.app_igw.id
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "subnet_association" {
  count          = length(aws_subnet.app_subnet)
  subnet_id      = aws_subnet.app_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Get Availability Zones
data "aws_availability_zones" "available" {}
