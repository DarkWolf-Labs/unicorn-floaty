output "server_ip" {
  description = "IP address of the Matrix server deployment"
  value       = module.compute-engine-vm.internal_ip
}