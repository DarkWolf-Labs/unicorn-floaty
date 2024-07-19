output "instance_id" {
  description = "ID of the Traccar EC2 instance"
  value       = module.traccar_server.instance_id
}

output "public_ip" {
  description = "Public IP address of the Traccar EC2 instance"
  value       = module.traccar_server.public_ip
}