resource "aws_efs_file_system" "SJ_efs" {
    creation_token = var.Name
    
    tags = {
      "Name" = var.Name
    }
}

resource "aws_efs_mount_target" "efs_private_mount_target" {
    for_each = var.subnet_ids
    file_system_id = aws_efs_file_system.SJ_efs.id
    subnet_id = each.value
    security_groups = [ var.vpc_security_group_ids ]
}