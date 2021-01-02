variable "instance_type" {}

resource "aws_instance" "default" {
  ami                    = "ami-01748a72bed07727c"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.default.id]
  user_data = <<EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
EOF
  tags = {
    Name = "walter"
  }
}
output "public_dns" {
  value = aws_instance.default.public_dns
}


#EC2向けセキュリティグループの定義
resource "aws_security_group" "default" {
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