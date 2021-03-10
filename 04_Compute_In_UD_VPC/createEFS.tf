resource "aws_efs_file_system" "SJ_efs" {
    creation_token = var.Name
    
    tags = {
      "Name" = var.Name
    }
}

resource "aws_efs_mount_target" "efs_private_mount_target" {
    for_each = data.aws_subnet_ids.ud_private_subnets_id.ids
    file_system_id = aws_efs_file_system.SJ_efs.id
    subnet_id = each.value
    security_groups = [ data.aws_security_group.ud_security_group.id ]
}