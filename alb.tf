resource "aws_lb" "walter" {
  name                       = "walter"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  enable_deletion_protection = false

  subnet = [
    aws_subnet.public_0.id,
    aws_subnet.public_1.id,
  ]
  #s3.tfで定義したS3バケットを指定
  access_logs {
    bucket  = aws_s3_bucket.alb_log.id
    enabled = true
  }

  security_groups = [
    module.http_sg.security_group_id,
    module.https_sg.security_group_id,
    module.http_redirect_sg.security_group_id,
  ]
}

output "alb_dns_name" {
  value = aws_lb.walter.dns_name
}

#HTTPリスナーの定義
resource "alb_lb_listener" "http" {
  load_balancer_arn = aws_lb.walter.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "これはHTTPですTESTですよ"
      status_code  = "200"
    }
  }
}