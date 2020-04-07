variable "create" {
  description = "Boolean to make module or not"
  type        = bool
  default     = true
}

########
# Label
########
variable "environment" {
  description = "The environment"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "The namespace to deploy into"
  type        = string
  default     = ""
}

variable "stage" {
  description = "The stage of the deployment"
  type        = string
  default     = ""
}

variable "network_name" {
  description = "The network name, ie kusama / mainnet"
  type        = string
  default     = ""
}

variable "owner" {
  description = "Owner of the infrastructure"
  type        = string
  default     = ""
}

variable "region" {
  description = "The DO region to deploy in"
  type        = string
  default     = "nyc1"
}

#####
# instance
#####
variable "node_name" {
  description = "Name of the node"
  type        = string
  default     = ""
}

variable "monitoring" {
  description = "Boolean for cloudwatch"
  type        = bool
  default     = false
}

variable "create_eip" {
  description = "Boolean to create elastic IP"
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Root volume size"
  type        = string
  default     = 0
}

variable "eph_volume_size" {
  description = "Ephemeral volume size"
  type        = string
  default     = 0
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "g-2vcpu-8gb"
}

variable "public_key_path" {
  description = "The path to the public ssh key"
  type        = string
  default     = ""
}

variable "security_group_id" {
  description = "The id of the security group to run in"
  type        = string
}
