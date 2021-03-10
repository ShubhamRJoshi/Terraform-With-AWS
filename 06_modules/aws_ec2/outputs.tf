output "server_public_ip" {
    value = aws_instance.SJ_ec2.*.public_ip
}