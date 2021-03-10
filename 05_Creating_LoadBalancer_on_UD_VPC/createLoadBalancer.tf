resource "aws_lb" "SJ_lb" {
    name = var.Name
    internal = false
    load_balancer_type = "network"
    subnets = data.aws_subnet_ids.ud_public_subnets_id.ids

    tags = {
        "Name" = var.Name
    }
}

resource "aws_lb_listener" "port_80" {
    load_balancer_arn = aws_lb.SJ_lb.arn
    port = 80
    protocol = "TCP"
    default_action {
        target_group_arn = aws_lb_target_group.targer_group_port_80.arn
        type = "forward"
    }
}

resource "aws_lb_target_group" "targer_group_port_80" {
    name = "${var.Name}-port-80"
    port = 80
    protocol = "TCP"
    vpc_id = data.aws_vpc.UD_vpc.id
    target_type = "instance"
}