output "public_ip_ipv4" {
  value = [
    for instance in civo_instance.veilid : instance.public_ip
  ]
}
