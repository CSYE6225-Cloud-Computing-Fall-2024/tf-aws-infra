resource "aws_route53_record" "app_a_record" {
  zone_id = var.route53_zone_id
  name    = "${var.subdomain}.${var.domain_name}"
  type    = var.record_type

  # Point to the EC2 instance's public IP address
  ttl     = var.record_ttl
  records = [aws_instance.app_instance.public_ip]

  # Optionally, you can set the alias to true if using an ALB or similar
  # alias {
  #   name                   = aws_lb.my_lb.dns_name
  #   zone_id                = aws_lb.my_lb.zone_id
  #   evaluate_target_health = true
  # }
}
