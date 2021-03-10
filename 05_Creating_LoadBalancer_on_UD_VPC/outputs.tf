output "server_ids" {
    value = data.aws_instances.target_servers.ids
}

output "load_balancer_dns" {
    value = aws_lb.SJ_lb.dns_name
}