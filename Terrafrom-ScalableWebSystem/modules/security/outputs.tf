output "sg_id_instance" {
  value = aws_security_group.instance.id
}

output "sg_id_alb" {
  value = aws_security_group.alb.id
}

output "sg_id_rds" {
  value = aws_security_group.rds.id
}