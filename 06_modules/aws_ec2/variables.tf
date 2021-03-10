variable "vpc_security_group_ids" {
    default = "demo"
}

variable "Name" {
    default = "demo"
}

variable "ami" {
    default = "ami-08962a4068733a2b6"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "key_name" {
    default = "terraform"
}

variable "subnet_id" {
    default = "subnet-c75a158b"
}

variable "servers" {
  default = 1
}