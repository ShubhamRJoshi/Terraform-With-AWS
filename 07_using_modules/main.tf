provider "aws" {
	region = terraform.workspace
}

provider "mysql" {
	endpoint = module.create_rds_mysql.database_endpoint
	username = module.create_rds_mysql.username
	password = var.db_password
}

terraform {
	backend "s3" {
		bucket = "bucket-for-managing-terraform-state-files"
		key = "07_using_modules.tfstate"
		region = "us-east-2"
	}
	required_providers {
		mysql = {
			source = "terraform-providers/mysql"
		}
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




variable "db_password" {
  type = string
  description = "Enter the admin password for MySQL Database"
}



module "create_vpc" {
	source = "../06_modules/aws_vpc"
}

module "create_ec2" {
	depends_on = [ module.create_vpc ]
	source = "../06_modules/aws_ec2"
	vpc_security_group_ids = module.create_vpc.security_group_id
	Name = "SJ-terraform-session"
	subnet_id = module.create_vpc.public_subnet_ids[0]
	servers = 2
}

module "create_efs" {
	depends_on = [ module.create_vpc ]
	source = "../06_modules/aws_efs"
	vpc_security_group_ids = module.create_vpc.security_group_id
	Name = "SJ-terraform-session"
	subnet_ids = toset(module.create_vpc.private_subnet_ids)
}

module "mount_efs_on_ec2" {
	depends_on = [ module.create_efs.efs_dns_name ]
	source = "../06_modules/mount_efs_on_ec2"
	# vpc_security_group_ids = module.create_vpc.security_group_id
	# Name = "SJ-terraform-session"
	# subnet_id = module.create_vpc.public_subnet_ids[0]
	efs_dns_name = module.create_efs.efs_dns_name
	servers = toset(module.create_ec2.server_public_ip)
}

module "install_apache_on_ec2" {
	source = "../06_modules/install_apache_on_ec2"
	# vpc_security_group_ids = module.create_vpc.security_group_id
	# Name = "SJ-terraform-session"
	# subnet_id = module.create_vpc.public_subnet_ids[0]
	servers = toset(module.create_ec2.server_public_ip)
}


module "create_rds_mysql" {
	depends_on = [ module.create_vpc ]
	source = "../06_modules/rds_mysql"
	vpc_security_group_ids = module.create_vpc.security_group_id
	# Name = "SJ-terraform-session"
	subnet_ids = toset(module.create_vpc.public_subnet_ids)
	allocated_storage = 5
	password = var.db_password
}



output "server_public_ip" {
	value = module.create_ec2.server_public_ip
}

output "efs_dns_name" {
    value = module.create_efs.efs_dns_name
}

output "database_endpoint" {
    value = module.create_rds_mysql.database_endpoint
}

output "username" {
    value = module.create_rds_mysql.username
}

resource "mysql_database" "thinknyx_database" {
	name = "thinknyx_database"
}

resource "mysql_user" "thinknyx_user" {
	user = "terraform"
	host = module.create_rds_mysql.database_endpoint
	plaintext_password = var.db_password
}

resource "mysql_grant" "thinknyx_access" {
	user = mysql_user.thinknyx_user.user
	host = mysql_user.thinknyx_user.host
	database = mysql_database.thinknyx_database.name
	privileges = ["SELECT"]
}