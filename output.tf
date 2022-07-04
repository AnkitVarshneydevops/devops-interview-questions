output "server_ip" {
  value = module.bastion.public_ip
}

output "pem_file" {
  value = module.bastion.pem_key
}