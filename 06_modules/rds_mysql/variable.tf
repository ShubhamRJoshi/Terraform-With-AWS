variable "vpc_security_group_ids" {
    default = "sg-08972322c9e5a72c3"
}

variable "subnet_ids" {
    default = ["subnet-c75a158b"]
}

variable "allocated_storage" {
    default = 5
}

variable "Name" {
    default = "sj-terraform-session"
}

variable "db_name" {
    default = "my_db"
}

variable "username" {
    default = "root"
}

variable "password" {
    default = "root1234"
    sensitive = true
}