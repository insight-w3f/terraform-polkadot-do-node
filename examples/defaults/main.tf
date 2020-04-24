provider "digitalocean" {}

variable "public_key_path" {}
variable "private_key_path" {}

module "network" {
  source                = "github.com/insight-w3f/terraform-polkadot-do-network.git?ref=master"
  sentry_node_instances = [module.defaults.instance_id]
}

module "defaults" {
  source            = "../.."
  create            = true
  create_eip        = true
  node_name         = "cci-test"
  security_group_id = module.network.sentry_security_group_id[0]
  public_key_path   = var.public_key_path
  private_key_path  = var.private_key_path
  eph_volume_size   = "200"
}
