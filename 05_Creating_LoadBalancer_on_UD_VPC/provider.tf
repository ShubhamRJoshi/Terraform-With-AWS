provider "aws" {
	region = "us-east-2"
}

terraform {
	backend "s3" {
		bucket = "bucket-for-managing-terraform-state-files"
		key = "05_Creating_LoadBalancer_on_UD_VPC.tfstate"
		region = "us-east-2"
	}
}