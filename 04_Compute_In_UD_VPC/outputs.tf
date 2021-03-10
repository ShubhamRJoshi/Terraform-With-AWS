output "vpc_id" {
    value = data.aws_vpc.UD_vpc.id
}

output "ud_private_subnets_id" {
    value = data.aws_subnet_ids.ud_private_subnets_id.ids
}

output "ud_public_subnets_id" {
    value = data.aws_subnet_ids.ud_public_subnets_id.ids
}

output "ud_security_group" {
    value = data.aws_security_group.ud_security_group.id
}

output "ec2_servers_public_ip" {
    value = { for id in (data.aws_subnet_ids.ud_public_subnets_id.ids) : id => aws_instance.SJ_ec2[id].public_ip}
}

output "efs_private_mount_target" {
    value = aws_efs_mount_target.efs_private_mount_target
}