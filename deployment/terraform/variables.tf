# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "hcloud_token" {
  sensitive = true
}

variable "server" {
  type = object({
    name         = string
    image        = string
    type         = string
    ipv4_enabled = bool
    ipv6_enabled = bool
  })
}

variable "ssh_key" {
  type = object({
    name = string
  })
}

variable "bamboo_agents" {
  type = list(object({
    uuid          = string
    id            = string
    name          = string
    docker_image  = string
    bamboo_server = string
    ram_min       = number
    ram_max       = number
    time_zone     = string
  }))
}

variable "DOCKER_CONFIG_JSON" {
  sensitive = true
}

variable "XALT_TECHNICAL_ASSISTANT_ID_RSA" {
  sensitive = true
}

variable "CONTAINER_DEMO_ID_RSA" {
  sensitive = true
}
