resource "aws_vpc" "travelstart" {
  cidr_block = "10.20.20.0/26"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "Travelstart-Application"
  }
}
resource "aws_subnet" "private-2a" {
  vpc_id            = aws_vpc.travelstart.id
  cidr_block        = "10.20.20.0/28"
  availability_zone = "us-east-2a"
  tags = {
    "Name" = "Travelstart-Application-private-2a"
  }
}
resource "aws_subnet" "private-2b" {
  vpc_id            = aws_vpc.travelstart.id
  cidr_block        = "10.20.20.16/28"
  availability_zone = "us-east-2b"
  tags = {
    "Name" = "Travelstart-Application-private-2b"
  }
}
resource "aws_subnet" "private-2c" {
  vpc_id            = aws_vpc.travelstart.id
  cidr_block        = "10.20.20.32/28"
  availability_zone = "us-east-2c"
  tags = {
    "Name" = "Travelstart-Application-private-2c"
  }
}
resource "aws_route_table" "travelstart-rt" {
  vpc_id = aws_vpc.travelstart.id
  tags = {
    "Name" = "Travelstart-Application-routing-table"
  }
}
resource "aws_route_table_association" "private-2a" {
  subnet_id      = aws_subnet.private-2a.id
  route_table_id = aws_route_table.travelstart-rt.id
}
resource "aws_route_table_association" "private-2b" {
  subnet_id      = aws_subnet.private-2b.id
  route_table_id = aws_route_table.travelstart-rt.id
}
resource "aws_route_table_association" "private-2c" {
  subnet_id      = aws_subnet.private-2c.id
  route_table_id = aws_route_table.travelstart-rt.id
}
resource "aws_internet_gateway" "travelstart-igw" {
  vpc_id = aws_vpc.travelstart.id
  tags = {
    "Name" = "Travelstart-Application-gateway"
  }
}
resource "aws_route" "internet-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.travelstart-rt.id
  gateway_id             = aws_internet_gateway.travelstart-igw.id
}
