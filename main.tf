locals {
  walter_instance_type = "t3.micro"
}

resource "aws_instance" "walter" {
  ami                    = "ami-01748a72bed07727c"
  instance_type          = local.walter_instance_type
  vpc_security_group_ids = [aws_security_group.walter_ec2.id]
  tags = {
    Name = "walter"
  }

  user_data = <<EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
  EOF
}

output "walter_public_dns" {
  value = aws_instance.walter.public_dns
}

provider "aws" {
  region = "ap-northeast-1"
}

#EC2向けセキュリティグループの定義
resource "aws_security_group" "walter_ec2" {
  name = "walter-ec2"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}