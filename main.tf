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

  ip                     = digitalocean_floating_ip.this[0].ip_address
  user                   = "root"
  private_key_path       = var.private_key_path
  playbook_file_path     = "${path.module}/ansible/main.yml"
  requirements_file_path = "${path.module}/ansible/requirements.yml"
  forks                  = 1

  playbook_vars = {
    node_exporter_user            = var.node_exporter_user,
    node_exporter_password        = var.node_exporter_password,
    project                       = var.project,
    polkadot_binary_url           = "https://github.com/w3f/polkadot/releases/download/v0.7.21/polkadot",
    polkadot_binary_checksum      = "sha256:af561dc3447e8e6723413cbeed0e5b1f0f38cffaa408696a57541897bf97a34d",
    node_exporter_binary_url      = "https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz",
    node_exporter_binary_checksum = "sha256:b2503fd932f85f4e5baf161268854bf5d22001869b84f00fd2d1f57b51b72424",
    polkadot_restart_enabled      = true,
    polkadot_restart_minute       = "50",
    polkadot_restart_hour         = "10",
    polkadot_restart_day          = "1",
    polkadot_restart_month        = "*",
    polkadot_restart_weekday      = "*",
    telemetry_url                 = var.telemetry_url,
    logging_filter                = var.logging_filter,
    relay_ip_address              = var.relay_node_ip,
    relay_p2p_address             = var.relay_node_p2p_address
  }
  module_depends_on = digitalocean_droplet.this
}