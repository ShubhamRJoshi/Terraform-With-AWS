resource "aws_instance" "SJ_ec2" {
    for_each = data.aws_subnet_ids.ud_public_subnets_id.ids
    ami = "ami-08962a4068733a2b6"
    instance_type = "t2.micro"
    key_name = "terraform"
    tags = {
      "Name" = var.Name
    }
    subnet_id = each.value
    vpc_security_group_ids = [ data.aws_security_group.ud_security_group.id ]
}