resource "aws_db_subnet_group" "main_db_subnet_group" {
  name        = "${var.rds_instance_name}-subnetgrp"
  description = "-${var.rds_instance_name} RDS subnet group"
  subnet_ids  = var.subnet_ids
  
  tags = merge(var.tags)
  
  lifecycle {
    ignore_changes = [name, description, tags]
  }
}

resource "aws_db_instance" "main_rds_instance" {
  identifier                   = var.rds_instance_name
  allocated_storage            = var.rds_allocated_storage
  deletion_protection          = var.rds_deletion_protection
  engine                       = var.rds_engine_type
  engine_version               = var.rds_engine_version
  instance_class               = var.rds_instance_class
  name                         = var.database_name
  username                     = var.database_user
  snapshot_identifier          = var.snapshot_identifier
  password                     = var.database_password
  multi_az                     = var.rds_is_multi_az
  storage_type                 = var.rds_storage_type
  final_snapshot_identifier    = "${var.environment}-${replace(timestamp(), ":", "-")}-Final-Snapshot"
  apply_immediately            = var.apply_immediately
  parameter_group_name         = var.db_parameter_group
  storage_encrypted            = false
  skip_final_snapshot          = true
  auto_minor_version_upgrade   = true
  copy_tags_to_snapshot        = true
  backup_retention_period      = 15
  maintenance_window           = "tue:00:04-tue:00:34"
  backup_window                = "23:32-00:02"
  performance_insights_enabled = var.performance_insights

  // Because we're assuming a VPC, we use this option, but only one SG id
  vpc_security_group_ids = var.rds_security_group_id

  // We're creating a subnet group in the module and passing in the name
  db_subnet_group_name = aws_db_subnet_group.main_db_subnet_group.name

  tags = merge(var.tags)
    
  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }
}

resource "aws_db_instance" "read_replica_rds_instance" {
  identifier                 = "${var.rds_instance_name}-replica-${count.index + 1}"
  allocated_storage          = var.rds_allocated_storage
  engine                     = var.rds_engine_type
  engine_version             = var.rds_engine_version
  instance_class             = var.read_replica_instance_type
  storage_type               = var.rds_storage_type
  replicate_source_db        = aws_db_instance.main_rds_instance.identifier
  parameter_group_name       = var.db_parameter_group
  skip_final_snapshot        = true
  auto_minor_version_upgrade = true

  // Because we're assuming a VPC, we use this option, but only one SG id
  vpc_security_group_ids = var.rds_security_group_id

  count = var.read_replica

  tags = merge(var.tags)

}
