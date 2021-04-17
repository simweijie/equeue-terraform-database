#----------------------------------------------------------------------------
# AWS
#----------------------------------------------------------------------------
aws_region = "us-east-1"

#----------------------------------------------------------------------------
# General
#----------------------------------------------------------------------------
vpc_cidr_block          = "10.0.0.0/16"
data_az1_cidr_block     = "10.0.192.0/20"
data_az2_cidr_block     = "10.0.208.0/20"
data_az3_cidr_block     = "10.0.224.0/20"

#----------------------------------------------------------------------------
# Security Group
#----------------------------------------------------------------------------
db_sg_ingress_cidr_rules = [
  { from_port: 3306, to_port: 3306, cidrs: ["10.0.128.0/18"], protocol: "tcp", description: "Logic Tier" }
]

db_sg_ingress_sg_rules = [
#   { from_port: 3306, to_port: 3306, sg_id: "sg-123456", protocol: "tcp", description: "Bastion Host SG" }
]

#----------------------------------------------------------------------------
# Database
#----------------------------------------------------------------------------
cluster_identifier      = "equeue-aurora-cluster"
# engine                  = "aurora-mysql"
# engine_version          = "5.7.mysql_aurora.2.03.2"
engine_mode             = "serverless"
availability_zones      = ["us-east-1a", "us-east-1b", "us-east-1c"]
database_name           = "equeue" # DatabaseName must begin with a letter and contain only alphanumeric characters.
# master_username         = "foo"
# master_password         = "bar"
backup_retention_period = 5
preferred_backup_window = "07:00-09:00"
enable_http_endpoint    = true
skip_final_snapshot     = true