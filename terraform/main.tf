module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = "10.20.0.0/16"
}

module "security_groups" {
  source = "./modules/security-groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

module "ec2" {
  source = "./modules/ec2"

  project_name      = var.project_name
  environment       = var.environment
  subnet_id         = module.vpc.app_subnet_ids[0]
  security_group_id = module.security_groups.app_security_group_id
  instance_type     = "t3.micro"
}


module "alb" {
  source = "./modules/alb"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_security_group_id
  app_instance_id       = module.ec2.instance_id
}



module "rds" {
  source = "./modules/rds"

  project_name         = var.project_name
  environment          = var.environment
  db_subnet_ids        = module.vpc.db_subnet_ids
  db_security_group_id = module.security_groups.db_security_group_id

  db_username = var.db_username
  db_password = var.db_password
}


resource "aws_secretsmanager_secret" "app_db" {
  name        = "${var.project_name}-${var.environment}-app-db"
  description = "Database credentials for the 3-tier application"

  recovery_window_in_days = 7

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "app_db" {
  secret_id = aws_secretsmanager_secret.app_db.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}


resource "aws_iam_role_policy" "app_db_secret_read" {
  name = "${var.project_name}-${var.environment}-app-db-secret-read"
  role = module.ec2.ssm_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = aws_secretsmanager_secret.app_db.arn
      }
    ]
  })
}


module "autoscaling" {
  source = "./modules/autoscaling"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  vpc_id                = module.vpc.vpc_id
  app_subnet_ids        = module.vpc.app_subnet_ids
  app_security_group_id = module.security_groups.app_security_group_id
  target_group_arn      = module.alb.flask_target_group_arn
  instance_profile_name = module.ec2.instance_profile_name

  db_endpoint = module.rds.db_endpoint
  db_port     = module.rds.db_port
  db_name     = "appdb"
  secret_arn  = aws_secretsmanager_secret.app_db.arn

  min_size         = 1
  desired_capacity = 1
  max_size         = 2
}
