data "aws_vpc" "UD_vpc" {
    filter {
        name = "tag:Name"
		values = [ var.Name ]
    }
}

data "aws_subnet_ids" "ud_private_subnets_id" {
	vpc_id = data.aws_vpc.UD_vpc.id
	filter {
		name = "tag:Name"
		values = [ "${var.Name}_private_subnet" ]
	}
}

data "aws_subnet_ids" "ud_public_subnets_id" {
	vpc_id = data.aws_vpc.UD_vpc.id
	filter {
		name = "tag:Name"
		values = [ "${var.Name}_public_subnet" ]
	}
}

data "aws_security_group" "ud_security_group" {
	vpc_id = data.aws_vpc.UD_vpc.id
	name = var.Name
}