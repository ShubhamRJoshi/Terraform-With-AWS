resource "null_resource" "mountEBS_on_EC2" {
	count = var.servers				# should import all the required variables before using them
	provisioner "remote-exec" {		# remote-exec, local-exec, file
		connection {
			type = "ssh"
			user = "ubuntu"
			host = aws_instance.ec2_server[count.index].public_ip
			private_key = file("C:/Users/joshi/Desktop/Terraform Training/terraform.pem")
		}
		inline = [
			"sudo mkfs -t ext4 /dev/xvdf",
			"sudo mount /dev/xvdf /opt",
			"sudo chown ubuntu:ubuntu /opt",
			"echo ${aws_instance.ec2_server[count.index].public_dns} > /opt/dns"
		]
	}
}