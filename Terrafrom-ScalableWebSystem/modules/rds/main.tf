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
# RDS
# #################################################
resource "aws_db_instance" "rds" {
  allocated_storage      = var.db_size
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_type
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.private.name
  replicate_source_db    = var.replication_source_db
  vpc_security_group_ids = [data.terraform_remote_state.security.outputs.sg_id_rds]

  engine   = var.replication_source_db == null ? var.db_engine : null
  db_name  = var.replication_source_db == null ? var.db_name : null
  username = var.replication_source_db == null ? var.db_username : null
  password = var.replication_source_db == null ? var.db_password : null
}

resource "aws_db_subnet_group" "private" {
  name       = "${var.project}-${var.environment}-rds-subnetgroup"
  subnet_ids = data.terraform_remote_state.network.outputs.public_subnet_ids
}



