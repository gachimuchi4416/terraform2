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