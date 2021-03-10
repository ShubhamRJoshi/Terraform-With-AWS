resource "aws_instance" "SJ_ec2" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    tags = {
      "Name" = var.Name
    }
    subnet_id = var.subnet_id
    vpc_security_group_ids = [ var.vpc_security_group_ids ]
    count = var.servers
}