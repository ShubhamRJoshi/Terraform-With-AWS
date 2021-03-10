provider "aws" {
	region = terraform.workspace
}

terraform {
	backend "s3" {
		bucket = "bucket-for-managing-terraform-state-files"
		key = "03_AWS_VPC.tfstate"
		region = "us-east-2"
	}
}

# terraform init

# If the above command fails for backend configuration, try the below command
# terraform init -reconfigure

# terraform workspace new us-east-2

# to switch between workspace :
# terraform workspace select <name of workspace>

# to know the available workspace:
# terraform workspace list 

# to view state of terraform
# terraform state list