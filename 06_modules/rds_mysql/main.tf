resource "aws_db_subnet_group" "mysql_db_subnet_group" {
  name        = "${var.Name}-subnet-group"
  description = "Terraform example RDS subnet group"
  subnet_ids  = var.subnet_ids
}

resource "aws_db_instance" "rds_mysql" {
  identifier                = "${var.Name}-mysql"
  allocated_storage         = var.allocated_storage
  engine                    = "mysql"
  engine_version            = "5.6.35"
  instance_class            = "db.t2.micro"
  storage_type              = "gp2"
  publicly_accessible       = true
  db_subnet_group_name      = aws_db_subnet_group.mysql_db_subnet_group.id
  vpc_security_group_ids    = [var.vpc_security_group_ids]
  name                      = var.db_name
  username                  = var.username
  password                  = var.password
  skip_final_snapshot       = true
  final_snapshot_identifier = "Ignore"
}