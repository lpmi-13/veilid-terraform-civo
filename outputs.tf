output "public_ip_ipv4" {
  value = [
    for ipv4 in civo_instance.veilid.public_ip : ipv4
  ]
}

