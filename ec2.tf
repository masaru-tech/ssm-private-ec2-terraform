resource "aws_instance" "private-ec2" {
  # Amazon Linux2
  ami               = "ami-0ff21806645c5e492"
  availability_zone = "ap-northeast-1a"
  ebs_optimized     = false
  instance_type     = "t2.nano"
  monitoring        = true
  subnet_id         = "${aws_subnet.subnet_a.id}"
  iam_instance_profile = "${aws_iam_instance_profile.ssm_instance_profile.name}"

  vpc_security_group_ids = ["${aws_security_group.allow_ssm.id}"]

  associate_public_ip_address = false
  source_dest_check           = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = false
  }

  tags = {
    Name = "private ec2"
  }
}

resource "aws_security_group" "allow_ssm" {
  name        = "allow_ssm"
  description = "allow_ssm"
  vpc_id      = "${aws_vpc.private_vpc.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.private_vpc.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}