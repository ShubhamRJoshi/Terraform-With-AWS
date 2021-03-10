data "aws_instances" "target_servers" {
    filter {
        name = "tag:Name"
		values = [ var.Name ]
    }
}

data "aws_vpc" "UD_vpc" {
    filter {
        name = "tag:Name"
        values = [ var.Name ]
    }
}

data "aws_subnet_ids" "ud_public_subnets_id" {
	vpc_id = data.aws_vpc.UD_vpc.id
	filter {
		name = "tag:Name"
		values = [ "${var.Name}_public_subnet" ]
	}
}