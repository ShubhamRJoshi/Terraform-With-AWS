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