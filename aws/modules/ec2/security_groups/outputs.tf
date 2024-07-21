output "security_group_id" {
  description = "ID of the created security group"
  value       = aws_security_group.server_sg.id
}

output "traccar_security_group_id" {
  value = aws_security_group.traccar_server_sg.id
}

output "openvpn_security_group_id" {
  value = aws_security_group.openvpn_server_sg.id
}

output "tak_security_group_id" {
  value = aws_security_group.tak_server_sg.id
}

output "matrix_security_group_id" {
  value = aws_security_group.matrix_server_sg.id
}

output "ubuntu_security_group_id" {
  value = aws_security_group.ubuntu_server_sg.id
}

