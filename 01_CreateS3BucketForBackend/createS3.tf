provider "aws" {
	region = "us-east-2"
}

resource "aws_s3_bucket" "bucket_for_backend" {
	bucket = "bucket-for-managing-terraform-state-files"
	acl = "private"
	
	tags = {
		Name = "SJ"
	}
	
	versioning {
		enabled = true
	}
}