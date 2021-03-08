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
	instance_type = "t2.micro"
	
	tags = {
		Name = "SJ-terraform-instance"
		Day = 1
	}
}