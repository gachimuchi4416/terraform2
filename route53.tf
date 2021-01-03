#ホストゾーンの作成
resource "aws_route53_zone" "walter" {
  name = "gachimuchi.fun"
}

resource "aws_route53_zone" "test_walter" {
  name = "test.gachimuchi.fun"
}

#ALBのDNSレコードを定義