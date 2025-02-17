# VPC for Aurora
resource "aws_vpc" "aurora_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "Aurora VPC"
  }
}

# Subnets for Aurora
resource "aws_subnet" "aurora_subnet1" {
  vpc_id            = aws_vpc.aurora_vpc.id
  cidr_block        = var.subnet_cidr1
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "Aurora Subnet 1"
  }
}

resource "aws_subnet" "aurora_subnet2" {
  vpc_id            = aws_vpc.aurora_vpc.id
  cidr_block        = var.subnet_cidr2
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "Aurora Subnet 2"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = [aws_subnet.aurora_subnet1.id, aws_subnet.aurora_subnet2.id]

  tags = {
    Name = "My DB Subnet Group"
  }
}

# Security Group for Aurora
resource "aws_security_group" "aurora_sg" {
  name        = "aurora-security-group"
  description = "Allow MySQL"
  vpc_id      = aws_vpc.aurora_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Aurora Security Group"
  }
}

# Aurora Cluster
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "aurora-cluster-example"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.07.1"
  database_name           = var.db_name
  master_username         = var.db_user
  master_password         = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]

  skip_final_snapshot     = true
}
