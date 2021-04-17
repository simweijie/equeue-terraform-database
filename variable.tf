variable "aws_region" {}

variable "vpc_cidr_block" {}
variable "data_az1_cidr_block" {}
variable "data_az2_cidr_block" {}
variable "data_az3_cidr_block" {}

variable "db_sg_ingress_cidr_rules" {}
variable "db_sg_ingress_sg_rules" {}

variable "cluster_identifier" {}
# variable "engine" {}
# variable "engine_version" {}
variable "engine_mode" {}
variable "availability_zones" {}
variable "database_name" {}
variable "master_username" {}
variable "master_password" {}
variable "backup_retention_period" {}
variable "preferred_backup_window" {}
variable "enable_http_endpoint" {}
variable "skip_final_snapshot" {}