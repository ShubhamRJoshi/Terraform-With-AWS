output "vpc_id" {
    value = aws_vpc.thinknyx_vpc.id
}

output "public_subnet_ids" {
    value = aws_subnet.thinknyx_public_subnet.*.id
}

output "private_subnet_ids" {
    value = aws_subnet.thinknyx_private_subnet.*.id
}

output "security_group_id" {
    value = aws_security_group.thinknyx_security_group.id
}