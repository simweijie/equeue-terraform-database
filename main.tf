provider "aws" {
  region  = var.aws_region
}

#----------------------------------------------------------------------------
# Data
#----------------------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
# Get VPC by CIDR block
data "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

# Get Data Tier Subnets by CIDR block
data "aws_subnet" "data_az1" {
  cidr_block = var.data_az1_cidr_block
}

data "aws_subnet" "data_az2" {
  cidr_block = var.data_az2_cidr_block
}

data "aws_subnet" "data_az3" {
  cidr_block = var.data_az3_cidr_block
}

#----------------------------------------------------------------------------
# Security Group
#----------------------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "db_sg" {
  name        = "Database Security Group"
  description = "Allow inbound logic tier traffic"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    Name = "Database Security Group"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule
# ingress for CIDR range
resource "aws_security_group_rule" "db_sg_ingress_cidr" {
  for_each = {
    for db_sg_ingress_cidr_rule in var.db_sg_ingress_cidr_rules: 
      "${db_sg_ingress_cidr_rule.description}-${db_sg_ingress_cidr_rule.protocol}" => db_sg_ingress_cidr_rule
  }

  type              = "ingress"
  security_group_id = aws_security_group.db_sg.id

  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidrs
}

# ingress for security group
resource "aws_security_group_rule" "db_sg_ingress_sg" {
  for_each = {
    for db_sg_ingress_sg_rule in var.db_sg_ingress_sg_rules: 
      "${db_sg_ingress_sg_rule.description}-${db_sg_ingress_sg_rule.protocol}" => db_sg_ingress_sg_rule
  }

  type                      = "ingress"
  security_group_id         = aws_security_group.db_sg.id

  from_port                 = each.value.from_port
  to_port                   = each.value.to_port
  protocol                  = each.value.protocol
  source_security_group_id  = each.value.sg_id
}

#----------------------------------------------------------------------------
# Database
#----------------------------------------------------------------------------
# https://aws.amazon.com/rds/aurora/pricing/
# https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&all-free-tier.q=database&all-free-tier.q_operator=AND
# db.t2.micro 750hrs/mth free for 12 months i.e. 1 db.t2.micro instance free for 12 months

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster
# https://aws.amazon.com/premiumsupport/knowledge-center/aurora-private-public-endpoints/
# defaults to private
resource "aws_rds_cluster" "cluster_aurora" {
  cluster_identifier      = var.cluster_identifier
  # engine                  = var.engine
  # engine_version          = var.engine_version
  engine_mode             = var.engine_mode
  availability_zones      = var.availability_zones
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  enable_http_endpoint    = var.enable_http_endpoint
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.sng_equeue.id
  skip_final_snapshot     = var.skip_final_snapshot
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
resource "aws_db_subnet_group" "sng_equeue" {
  name       = "equeue_db_subnet_group"
  subnet_ids = [data.aws_subnet.data_az1.id, data.aws_subnet.data_az2.id, data.aws_subnet.data_az3.id]

  tags = {
    Name = "Equeue DB Subnet Group"
  }
}