resource "aws_vpc" "thinknyx_vpc" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        "Name" = var.Name
    }
}

resource "aws_subnet" "thinknyx_public_subnet" {
    for_each = toset(var.public_subnet_cidr_blocks)
    vpc_id = aws_vpc.thinknyx_vpc.id
    cidr_block = each.value
    map_public_ip_on_launch = true

    tags = {
      "Name" = "${var.Name}_public_subnet"
    }
}

resource "aws_subnet" "thinknyx_private_subnet" {
    for_each = toset(var.private_subnet_cidr_blocks)
    vpc_id = aws_vpc.thinknyx_vpc.id
    cidr_block = each.value
    map_public_ip_on_launch = false     # by default this value is false

    tags = {
      "Name" = "${var.Name}_private_subnet"
    }
}

resource "aws_internet_gateway" "thinknyx_igw" {
    vpc_id = aws_vpc.thinknyx_vpc.id

    tags = {
        "Name" = var.Name
    }
}

resource "aws_route_table" "thinknyx_route_table_igw" {
    vpc_id = aws_vpc.thinknyx_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.thinknyx_igw.id
    }

    tags = {
      "Name" = "${var.Name}_IGW"
    }
}

resource "aws_route_table_association" "thinknyx_route_table_ign_public_subnets" {
    for_each = toset(var.public_subnet_cidr_blocks)
    subnet_id = aws_subnet.thinknyx_public_subnet[each.value].id
    route_table_id = aws_route_table.thinknyx_route_table_igw.id
}

resource "aws_eip" "thinknyx_natgw_eip" {
    tags = {
      "Name" = var.Name
    }
}

resource "aws_nat_gateway" "thinknyx_natgw" {
    subnet_id = aws_subnet.thinknyx_public_subnet[var.public_subnet_cidr_blocks[0]].id
    allocation_id = aws_eip.thinknyx_natgw_eip.id

    tags = {
      "Name" = var.Name
    }
}

resource "aws_route_table" "thinknyx_route_table_natgw" {
    vpc_id = aws_vpc.thinknyx_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.thinknyx_natgw.id
    }

    tags = {
      "Name" = "${var.Name}_NATGW"
    }
}

resource "aws_route_table_association" "thinknyx_route_table_igw_private_subnets" {
    for_each = toset(var.private_subnet_cidr_blocks)
    subnet_id = aws_subnet.thinknyx_private_subnet[each.value].id
    route_table_id = aws_route_table.thinknyx_route_table_natgw.id
}

resource "aws_security_group" "thinknyx_security_group" {
    vpc_id = aws_vpc.thinknyx_vpc.id
    name = var.Name
    description = "Managed by Terraform"

    tags = {
      "Name" = var.Name
    }

    ingress = [ {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "SSH Port"
      from_port = 22
      ipv6_cidr_blocks = [  ]
      prefix_list_ids = [  ]
      protocol = "tcp"
      security_groups = [  ]
      self = false
      to_port = 22
    } ]

    egress = [ {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "All traffic Open"
      from_port = 0
      ipv6_cidr_blocks = [  ]
      prefix_list_ids = [  ]
      protocol = "-1"
      security_groups = [  ]
      self = false
      to_port = 0
    } ]
}