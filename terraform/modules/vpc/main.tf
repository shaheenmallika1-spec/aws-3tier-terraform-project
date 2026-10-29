data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  subnets = {
    public_a = {
      cidr     = "10.20.1.0/24"
      az_index = 0
      tier     = "public"
    }
    public_b = {
      cidr     = "10.20.2.0/24"
      az_index = 1
      tier     = "public"
    }
    app_a = {
      cidr     = "10.20.11.0/24"
      az_index = 0
      tier     = "app"
    }
    app_b = {
      cidr     = "10.20.12.0/24"
      az_index = 1
      tier     = "app"
    }
    db_a = {
      cidr     = "10.20.21.0/24"
      az_index = 0
      tier     = "db"
    }
    db_b = {
      cidr     = "10.20.22.0/24"
      az_index = 1
      tier     = "db"
    }
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_subnet" "this" {
  for_each = local.subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = data.aws_availability_zones.available.names[each.value.az_index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-${each.key}"
    Environment = var.environment
    Project     = var.project_name
    Tier        = each.value.tier
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name    = "${var.project_name}-${var.environment}-igw"
    Project = var.project_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name    = "${var.project_name}-${var.environment}-public-rt"
    Project = var.project_name
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = toset(["public_a", "public_b"])

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name    = "${var.project_name}-${var.environment}-app-rt"
    Project = var.project_name
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-eip"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.this["public_a"].id

  depends_on = [aws_internet_gateway.this]

  tags = {
    Name        = "${var.project_name}-${var.environment}-nat"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_route" "app_nat" {
  route_table_id         = aws_route_table.app.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "app" {
  for_each = toset(["app_a", "app_b"])

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.app.id
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name    = "${var.project_name}-${var.environment}-db-rt"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "db" {
  for_each = toset(["db_a", "db_b"])

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.db.id
}