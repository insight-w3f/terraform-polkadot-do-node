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
variable "create_eip" {
  description = "Boolean to create elastic IP"
  type        = bool
  default     = false
}
