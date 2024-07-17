output "server_ip" {
  description = "IP address of the TAK server deployment"
  value       = module.compute-engine-vm.internal_ip
}