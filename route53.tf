#ホストゾーンの作成
resource "aws_route53_zone" "walter" {
  name = "gachimuchi.fun"
}

resource "aws_route53_zone" "test_walter" {
  name = "test.gachimuchi.fun"
}

#ALBのDNSレコードを定義
resource "aws_route53_record" "walter" {
  zone_id = aws_route53_zone.walter.zone_id
  name    = aws_route53_zone.walter.name
  type    = "A"

  alias {
    name                   = aws_lb.walter.dns_name
    zone_id                = aws_lb.walter.zone_id
    evaluate_target_health = true
  }
}

output "domain_name" {
  value = aws_route53_record.walter.name
}