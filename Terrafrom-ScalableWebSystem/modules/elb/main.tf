# #################################################
# data
# #################################################
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket         = var.bucket_name
    key            = var.backet_key
    region         = var.region
    dynamodb_table = var.dynamodb_table
  }
}

# #################################################
# ALB
# #################################################
resource "aws_lb" "alb" {
  name               = "${var.project}-${var.environment}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.terraform_remote_state.network.outputs.public_subnet_ids
}

resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.http_port
  protocol          = var.http_protocol
  # パスが存在しなかったときのアクションを指定。aws_lb_listenerにdefault_actionは1つまでしか設定不可。
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "alb" {
  listener_arn = aws_lb_listener.alb.arn
  priority     = 100
  # すべてのパスパターンに対応
  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}

resource "aws_lb_target_group" "alb" {
  name     = "${var.project}-${var.environment}-alb-tg"
  port     = var.http_port
  protocol = var.http_protocol
  vpc_id   = data.terraform_remote_state.network.outputs.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# #################################################
# Security group
# #################################################
resource "aws_security_group" "alb" {
  name   = "${var.project}-${var.environment}-alb-sg"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

