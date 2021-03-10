output "database_endpoint" {
    value = aws_db_instance.rds_mysql.endpoint
}

output "username" {
    value = aws_db_instance.rds_mysql.username
}