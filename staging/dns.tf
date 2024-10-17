###################### DNS ######################

resource "aws_route53_record" "stg_record" {
  zone_id = data.aws_route53_zone.my_domain.zone_id
  name    = "${var.my_domain_env}.${var.my_domain_name}"
  type    = var.record_type_A

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = var.route53_target_health
  }
}

resource "aws_route53_record" "www_stg_record" {
  zone_id = data.aws_route53_zone.my_domain.zone_id
  name    = "www.${var.my_domain_env}.${var.my_domain_name}"
  type    = var.record_type_A

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = var.route53_target_health
  }
}