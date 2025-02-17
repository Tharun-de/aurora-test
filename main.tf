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
resource "aws_rds_cluster" "aurora_serverless_cluster" {
  cluster_identifier      = "aurora-serverless-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.07.1" # Make sure this version is compatible with serverless
  database_name           = "myserverlessdb"
  master_username         = "customadmin"
  master_password         = "securepassword!123"

  db_subnet_group_name    = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]

  skip_final_snapshot     = true  # This should be false in production for data durability

  # Serverless-specific settings
  engine_mode             = "serverless"
  scaling_configuration {
    auto_pause               = true  # Automatically pause the database when idle
    min_capacity             = 1     # ACU (Aurora Compute Units)
    max_capacity             = 2     # Scale up to 2 ACU
    seconds_until_auto_pause = 300   # Auto-pause after 5 minutes of inactivity
  }
}

output "aurora_serverless_cluster_endpoint" {
  value = aws_rds_cluster.aurora_serverless_cluster.endpoint
}

output "aurora_serverless_cluster_read_endpoint" {
  value = aws_rds_cluster.aurora_serverless_cluster.reader_endpoint
}

