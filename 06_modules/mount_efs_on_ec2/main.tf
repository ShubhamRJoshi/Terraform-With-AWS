resource "null_resource" "mountEFS_onEC2" {
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
            "sudo apt-get update -y && sudo apt-get install -y nfs-common",
            "mkdir -p ~/efs",
            "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${var.efs_dns_name}:/ ~/efs",
            "sudo chown ubuntu:ubuntu ~/efs"
        ]
    }
}