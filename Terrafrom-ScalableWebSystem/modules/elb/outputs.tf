output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "The domain name of teh load balancer"
}

output "target_group_arn" {
  value = aws_lb_target_group.alb.arn
}