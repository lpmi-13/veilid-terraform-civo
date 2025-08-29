terraform {
  required_version = ">= 1.5.0"

  required_providers {
    civo = {
      source  = "civo/civo"
      version = "~> 1.1.5"
    }
  }
}

locals {
  number_of_instances = 1
}

# the list of regions can be found at https://www.civo.com/docs/overview/regions
provider "civo" {
  region = "LON1"
}

resource "civo_network" "veilid" {
  label = "veilid-network"
}

data "civo_disk_image" "ubuntu_24" {
  filter {
    key    = "name"
    values = ["ubuntu-noble"]
  }
}

resource "civo_instance" "veilid" {
  count       = local.number_of_instances
  hostname    = "veilid"
  tags        = ["veilid"]
  notes       = "running a veilid instance"
  firewall_id = civo_firewall.veilid.id
  network_id  = civo_network.veilid.id
  # this is the smallest possible instance
  size       = "g4s.xsmall"
  disk_image = data.civo_disk_image.ubuntu_24.diskimages[0].id
  sshkey_id  = civo_ssh_key.veilid.id

  script = file("./setup-veilid.yaml")
}

resource "civo_ssh_key" "veilid" {
  name       = "veilid-key"
  public_key = file("./veilid-key.pub")
}
