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
# launch template
# #################################################
resource "aws_launch_template" "lt" {
  #name                   = "${var.project}-${var.environment}-lt"
  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data              = var.user_data

  lifecycle {
    create_before_destroy = true
  }
}

# #################################################
# Security group
# #################################################
resource "aws_security_group" "instance" {
  name   = "${var.project}-${var.environment}-instance-sg"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
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

# #################################################
# Auto Scaling Group
# #################################################
resource "aws_autoscaling_group" "asg" {
  name                      = "${var.project}-${var.environment}-ver${aws_launch_template.lt.latest_version}-asg"
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_type         = "EC2"
  health_check_grace_period = 300
  vpc_zone_identifier       = data.terraform_remote_state.network.outputs.public_subnet_ids
  min_elb_capacity = var.min_size
  target_group_arns = [ var.target_group_arns ]

  lifecycle {
    create_before_destroy = true
  }

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
}