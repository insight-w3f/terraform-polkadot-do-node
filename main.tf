module "label" {
  source = "github.com/robc-io/terraform-null-label.git?ref=0.16.1"
  tags = {
    NetworkName = var.network_name
    Owner       = var.owner
    Terraform   = true
    VpcType     = "main"
  }

  environment = var.environment
  namespace   = var.namespace
  stage       = var.stage
}

resource "digitalocean_floating_ip" "this" {
  count  = var.create_eip && var.create ? 1 : 0
  region = var.region
}

resource "digitalocean_ssh_key" "this" {
  name       = var.node_name
  public_key = file(var.public_key_path)
}

resource "digitalocean_volume" "eph" {
  name                    = "${var.node_name}-eph"
  region                  = var.region
  size                    = var.eph_volume_size
  initial_filesystem_type = "ext4"
}

resource "digitalocean_droplet" "this" {
  count  = var.create ? 1 : 0
  image  = "ubuntu-18-04-x64"
  name   = var.node_name
  region = var.region
  size   = var.instance_type

  ssh_keys = [digitalocean_ssh_key.this.fingerprint]
  tags     = [var.security_group_id]
}

resource "digitalocean_floating_ip_assignment" "this" {
  droplet_id = digitalocean_droplet.this[0].id
  ip_address = digitalocean_floating_ip.this[0].ip_address
}

resource "digitalocean_volume_attachment" "this" {
  droplet_id = digitalocean_droplet.this[0].id
  volume_id  = digitalocean_volume.eph.id
}

module "ansible" {
  source = "github.com/insight-infrastructure/terraform-aws-ansible-playbook.git"

  inventory_template = "${path.module}/ansible_inventory.tpl"

  inventory_template_vars = {
    node-ip   = digitalocean_floating_ip_assignment.this.ip_address
    node-name = digitalocean_droplet.this[0].name

    wireguard_validator_pubkey = var.wireguard_validator_pubkey
    validator_vpn_peer_addr    = var.validator_vpn_peer_addr
    validator_ip               = var.validator_ip
  }

  playbook_file_path = "${path.module}/ansible/main.yml"

  playbook_vars = {
    node_exporter_enabled = false
  }

  user             = "root"
  private_key_path = var.private_key_path
  become           = false
}