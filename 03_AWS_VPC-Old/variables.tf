variable "cidr_block" {
    default = "10.10.0.0/16"
}

variable "Name" {
    default = "SJ-terraform-session"
}

variable "public_subnet_cidr_blocks" {
    type = list
    default = ["10.10.10.0/24", "10.10.20.0/24"]
}

variable "private_subnet_cidr_blocks" {
    type = list
    default = ["10.10.30.0/24", "10.10.40.0/24", "10.10.50.0/24"]
}