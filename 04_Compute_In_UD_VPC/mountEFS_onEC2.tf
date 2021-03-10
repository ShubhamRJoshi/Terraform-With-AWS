resource "null_resource" "mountEFS_onEC2" {
    depends_on = [ aws_efs_mount_target.efs_private_mount_target ]
    for_each = data.aws_subnet_ids.ud_public_subnets_id.ids
    provisioner "remote-exec" {
        connection {
            type = "ssh"
            user = "ubuntu"
            host = aws_instance.SJ_ec2[each.value].public_ip
            private_key = file("./../../terraform.pem")
        }
        inline = [
            "sudo apt-get update -y && sudo apt-get install -y nfs-common",
            "mkdir -p ~/efs",
            "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.SJ_efs.dns_name}:/ ~/efs",
            "sudo chown ubuntu:ubuntu ~/efs"
        ]
    }
}