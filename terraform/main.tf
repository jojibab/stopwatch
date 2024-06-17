resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "us-east-1a"
}
resource "aws_instance" "ubuntu_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  security_groups = aws_security_group.allow_ssh.id
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install docker.io -y
              sudo usermod -aG docker $USER
              newgrp docker
              sudo chmod 777 /var/run/docker.sock
              echo dckr_pat_Qdt6UgFFu7GG3krulmCB_D5w5Kg | docker login -u jojibabu1043 --password-stdin
              docker run -p 3000:3000 jojibabu1043/stopwatch:latest
              EOF


  tags = {
    Name = "UbuntuInstance"
  }
  depends_on = [ aws_security_group.allow_ssh, aws_vpc.vpc ]
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
