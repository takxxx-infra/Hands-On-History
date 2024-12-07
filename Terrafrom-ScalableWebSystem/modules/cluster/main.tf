# #################################################
# data
# #################################################
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket         = var.bucket_name
    key            = var.network_backet_key
    region         = var.region
    dynamodb_table = var.dynamodb_table
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket         = var.bucket_name
    key            = var.security_backet_key
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
  vpc_security_group_ids = [data.terraform_remote_state.security.outputs.sg_id_instance]
  user_data              = var.user_data

  lifecycle {
    create_before_destroy = true
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