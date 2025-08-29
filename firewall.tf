resource "civo_firewall" "veilid" {
  name                 = "veilid-firewall"
  network_id           = civo_network.veilid.id
  create_default_rules = false # Needs to be false when custom rules are applied.
  ingress_rule {
    label      = "ssh"
    protocol   = "tcp"
    port_range = "22"
    cidr       = ["0.0.0.0/0"]
    action     = "allow"
  }

  ingress_rule {
    label      = "veilid-tcp-5150"
    protocol   = "tcp"
    port_range = "5150"
    cidr       = ["0.0.0.0/0"]
    action     = "allow"
  }

  ingress_rule {
    label      = "veilid-udp-5150"
    protocol   = "udp"
    port_range = "22"
    cidr       = ["0.0.0.0/0"]
    action     = "allow"
  }

  egress_rule {
    label      = "all"
    protocol   = "tcp"
    port_range = "1-65535"
    cidr       = ["0.0.0.0/0"]
    action     = "allow"
  }
}
