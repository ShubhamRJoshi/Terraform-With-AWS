provider "aws" {
	region = "us-east-2"
}

terraform {
	backend "s3" {
		bucket = "bucket-for-managing-terraform-state-files"
		key = "02_CreateEC2ServerWithAddonEBS.tfstate"
		region = "us-east-2"
	}
}

resource "aws_instance" "ec2_server" {
	ami = "ami-08962a4068733a2b6"
	instance_type = "t2.nano"
	
	tags = {
		Name = var.name
		Day = var.day
	}
	count = var.servers
	availability_zone = var.availability_zone
	key_name = "terraform"
}

resource "aws_ebs_volume" "ebs_volume" {
	count = var.servers
	availability_zone = var.availability_zone
	size = 4
	
	tags = {
		Name = var.name
		Day = var.day
	}
}

resource "aws_volume_attachment" "ebs_volume_attachment" {
	count = var.servers
	volume_id = aws_ebs_volume.ebs_volume[count.index].id
	instance_id = aws_instance.ec2_server[count.index].id
	skip_destroy = true
	device_name = "/dev/sdf"
}

# terraform apply --auto-approve -var servers=2

output "public_ips_of_ec2_server" {
	value = aws_instance.ec2_server.*.public_ip
}

output "private_ips_of_ec2_server" {
	value = aws_instance.ec2_server.*.private_ip
}