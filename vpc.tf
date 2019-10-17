locals {
  name = "private vpc"
}

# VPC
resource "aws_vpc" "private_vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name}"
  }
}

# Subnet
resource "aws_subnet" "subnet_a" {
  vpc_id            = "${aws_vpc.private_vpc.id}"
  cidr_block        = "192.168.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${local.name} subnet a"
  }
}

# VPC endpoint
resource "aws_vpc_endpoint" "ssm" {
  vpc_id       = "${aws_vpc.private_vpc.id}"
  service_name = "com.amazonaws.${data.aws_region.current.name}.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids          = ["${aws_subnet.subnet_a.id}"]
  security_group_ids = [
    "${aws_security_group.allow_ssm.id}",
  ]

  # trueにしないとssmが認識しないので繋げない
  # trueにするにはvpcのenable_dns_support,enable_dns_hostnamesの両方trueにする必要あり
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id       = "${aws_vpc.private_vpc.id}"
  service_name = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids          = ["${aws_subnet.subnet_a.id}"]
  security_group_ids = [
    "${aws_security_group.allow_ssm.id}",
  ]

  # trueにしないとssmが認識しないので繋げない
  # trueにするにはvpcのenable_dns_support,enable_dns_hostnamesの両方trueにする必要あり
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id       = "${aws_vpc.private_vpc.id}"
  service_name = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids          = ["${aws_subnet.subnet_a.id}"]
  security_group_ids = [
    "${aws_security_group.allow_ssm.id}",
  ]

  # trueにしないとssmが認識しないので繋げない
  # trueにするにはvpcのenable_dns_support,enable_dns_hostnamesの両方trueにする必要あり
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id       = "${aws_vpc.private_vpc.id}"
  service_name = "com.amazonaws.${data.aws_region.current.name}.ec2"
  vpc_endpoint_type = "Interface"

  subnet_ids          = ["${aws_subnet.subnet_a.id}"]
  security_group_ids = [
    "${aws_security_group.allow_ssm.id}",
  ]

  # trueにしないとssmが認識しないので繋げない
  # trueにするにはvpcのenable_dns_support,enable_dns_hostnamesの両方trueにする必要あり
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.private_vpc.id}"
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = ["${aws_vpc.private_vpc.default_route_table_id}"]
}