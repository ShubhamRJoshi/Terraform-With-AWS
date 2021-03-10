resource "null_resource" "install_apache_on_ec2" {
    # for_each = data.aws_subnet_ids.ud_public_subnets_id.ids
    for_each = var.servers
    provisioner "remote-exec" {
        connection {
            type = "ssh"
            user = "ubuntu"
            host = each.value
            private_key = file("./../../terraform.pem")
        }
        inline = [
            "sudo apt-get update -y && sudo apt-get install -y apache2",
            "sudo ufw allow 'Apache'"
        ]
    }
}