# Basic infrastructure for single-node k3s + services
locals {
  name = "${var.project_name}"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.name}-vpc"
  }
}

data "aws_availability_zones" "azs" {}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.azs.names[0]
  tags = {
    Name = "${local.name}-subnet"
  }
}

resource "aws_security_group" "k3s_sg" {
  name        = "${local.name}-sg"
  description = "Allow SSH from your IP, HTTP and NodePort"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from your IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # NodePort example (frontend nodePort 30080). Add specific ports only to limit exposure.
  ingress {
    description = "Frontend NodePort example 30080"
    from_port   = 30080
    to_port     = 30080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name}-sg"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "${local.name}-key"
  public_key = file(var.ssh_public_key_path)
}

resource "aws_instance" "k3s_node" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]
  key_name               = aws_key_pair.deployer.key_name

  tags = {
    Name = "${local.name}-k3snode"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Instance ready. You can provision with Ansible from your control machine.'"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(regex("^~/(.*)$", pathexpand(var.ssh_public_key_path) ) == "" ? "" : pathexpand(replace(var.ssh_public_key_path, ".pub$", "")))
      host        = self.public_ip
    }
  }
}
