resource "aws_db_subnet_group" "this" {
  name        = "${var.project_name}-${var.environment}-db-subnet-group"
  description = "Private DB subnets for AWS 3-tier project"
  subnet_ids  = var.db_subnet_ids
}

resource "aws_db_instance" "this" {
  identifier     = "${var.project_name}-${var.environment}-mysql"
  engine         = "mysql"
  instance_class = "db.t4g.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "appdb"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_security_group_id]

  publicly_accessible     = false
  multi_az                = false
  storage_encrypted       = true
  backup_retention_period = 0

  auto_minor_version_upgrade = true
  deletion_protection        = false
  skip_final_snapshot        = true
}