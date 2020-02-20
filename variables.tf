//
// Module: tf_aws_rds
//

// RDS Instance Variables

variable "rds_instance_name" {}

variable "performance_insights" {
  default = true
}

variable "snapshot_identifier" {}

variable "rds_is_multi_az" {
  default = "false"
}

variable "rds_deletion_protection" {
  default = true
}

variable "rds_storage_type" {
  default = "gp2"
}

variable "rds_allocated_storage" {
  description = "The allocated storage in GBs"

  // You just give it the number, e.g. 10
}

variable "rds_engine_type" {
  // Valid types are  // - mysql  // - postgres  // - oracle-*  // - sqlserver-*  // See http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html  // --engine
}

variable "rds_engine_version" {
  // For valid engine versions, see:  // See http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html  // --engine-version
}

variable "rds_instance_class" {}

variable "database_name" {
  description = "The name of the database to create"
}

variable "database_user" {}
variable "database_password" {}

variable "rds_security_group_id" {
  type = set(string)
}

variable "db_parameter_group" {
  default = "default.mysql5.6"
}

// RDS Subnet Group Variables
variable "environment" {}

variable "apply_immediately" {}
variable "read_replica" {}

variable "read_replica_instance_type" {
  default = ""
}

variable "subnet_ids" {
  type = set(string)
}

variable "tags" {
  type        = map
  description = "Tags for rds"
  default     = {}
}
