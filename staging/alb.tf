###################### Target Group ######################

resource "aws_lb_target_group" "tg" {
  name     = "${var.env}-tg-80"
  port     = var.http_port
  protocol = var.http_protocol
  vpc_id   = aws_vpc.this.id

  health_check {
    healthy_threshold = 2
    interval          = 10
  }
}

###################### Load Balancer ######################

resource "aws_lb" "alb" {
  name                       = "${var.env}-alb"
  subnets                    = [for subnet in aws_subnet.public : subnet.id]
  internal                   = var.internet_facing
  security_groups            = [aws_security_group.public.id]
  load_balancer_type         = var.lb_type
  drop_invalid_header_fields = true

  tags = {
    Name        = "${var.env}-alb"
    Environment = var.env
  }
}

###################### Listeners ######################

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.https_port
  protocol          = var.https_protocol
  ssl_policy        = var.alb_ssl_profile
  certificate_arn   = data.aws_acm_certificate.alb_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_listener" "http_to_https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.http_port
  protocol          = var.http_protocol

  default_action {
    type = "redirect"

    redirect {
      port        = var.https_port
      protocol    = var.https_protocol
      status_code = "HTTP_301"
    }
  }
}

###################### Listener Rules ######################

resource "aws_lb_listener_rule" "web_rule" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    host_header {
      values = ["www.${var.my_domain_env}.${var.my_domain_name}", "${var.my_domain_env}.${var.my_domain_name}"]
    }
  }
}
