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
