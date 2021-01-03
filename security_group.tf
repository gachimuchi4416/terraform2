#セキュリティグループの定義
resource "aws_security_group" "walter" {
  name   = "walter-sg"
  vpc_id = aws_vpc.walter.id
  tags = {
    Name = "walter-sg"
  }
}
#インバウンドの定義
resource "aws_security_group_rule" "ingress_walter-sg" {
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.walter.id
}
#アウトバウンドの定義
resource "aws_security_group_rule" "egress_walter-sg" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.walter.id
}

#モジュールを利用したセキュリティグループの定義
module "walter_module_sg" {
  source      = "./security_group"
  name        = "module-sg"
  vpc_id      = aws_vpc.walter.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}

#ALBで使用するセキュリティグループの定義
module "http_sg" {
  source      = "./security_group"
  name        = "http-sg"
  vpc_id      = aws_vpc.walter.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}

module "https_sg" {
  source      = "./security_group"
  name        = "https-sg"
  vpc_id      = aws_vpc.walter.id
  port        = 443
  cidr_blocks = ["0.0.0.0/0"]
}

module "http_redirect_sg" {
  source      = "./security_group"
  name        = "http-redirect-sg"
  vpc_id      = aws_vpc.walter.id
  port        = 8080
  cidr_blocks = ["0.0.0.0/0"]
}