
/* VPC*/

resource "aws_vpc" "my_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
}


/* Internet gateway for the public subnet */

resource "aws_internet_gateway" "my_ig" {
  vpc_id = "${aws_vpc.my_vpc.id}"
}

/* Elastic IP for NAT */

resource "aws_eip" "nat_eip" {
  vpc        = true
}

/* NAT */

resource "aws_nat_gateway" "my_nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${aws_subnet.public_subnet.id}"
}

/* Public subnet */

resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.my_vpc.id}"
  cidr_block              = "${var.public_subnet_cidr}"
  map_public_ip_on_launch = true
}

/* Private subnet */

resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.my_vpc.id}"
  cidr_block              = "${var.private_subnet_cidr}"
  map_public_ip_on_launch = false
}

/* Routing table for private subnet */

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.my_vpc.id}"
}

/* Routing table for public subnet */

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.my_vpc.id}"
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.my_ig.id}"
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.my_nat.id}"
}

/* Route table associations */

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.private.id}"
}

/* VPC's Default Security Group */
resource "aws_security_group" "default" {
  name        = default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
}

