locals {
  web_instance_type = {
    stage = "t3.micro"
    prod = "t2.micro"
  }[terraform.workspace]

  web_instance_count = {
    stage = 1
    prod = 2
  }[terraform.workspace]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }

  owners = [
    "099720109477"]
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "Open 22 port for SSH connections"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
}

resource "aws_key_pair" "home_laptop" {
  key_name = "home-laptop-key-2"
  public_key = var.SSH_KEY
}

resource "aws_instance" "web" {
  ami = data.aws_ami.ubuntu.id
  instance_type = local.web_instance_type
  count = local.web_instance_count
  security_groups = [
    aws_security_group.allow_ssh.name
  ]
  key_name = aws_key_pair.home_laptop.key_name

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Ubuntu-20.04-t2"
  }
}

resource "aws_instance" "web-foreach" {
  ami = data.aws_ami.ubuntu.id
  instance_type = local.web_instance_type
  for_each = {
    stage: 1
    prod: 2
  }
  security_groups = [
    aws_security_group.allow_ssh.name
  ]
  key_name = aws_key_pair.home_laptop.key_name

  tags = {
    Name = "Ubuntu-20.04-t2"
    env = each.key
  }
}
