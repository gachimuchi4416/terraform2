locals {
  walter_instance_type = "t3.micro"
}

resource "aws_instance" "walter" {
  ami           = "ami-01748a72bed07727c"
  instance_type = local.walter_instance_type
  tags = {
    Name = "walter"
  }

  user_data = <<EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
  EOF
}

output "walter_instance_id" {
  value  = aws_instance.walter.id
}

provider "aws" {
  region  = "ap-northeast-1"
}