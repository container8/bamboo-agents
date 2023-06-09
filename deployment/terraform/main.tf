resource "hcloud_server" "main" {
  name        = var.server.name
  image       = var.server.image
  server_type = var.server.type
  public_net {
    ipv4_enabled = var.server.ipv4_enabled
    ipv6_enabled = var.server.ipv6_enabled
  }

  user_data = base64encode(
    templatefile("${path.module}/user_data.sh.tftpl",
      {
        bamboo_agents                   = var.bamboo_agents
        DOCKER_CONFIG_JSON              = var.DOCKER_CONFIG_JSON
        XALT_TECHNICAL_ASSISTANT_ID_RSA = var.XALT_TECHNICAL_ASSISTANT_ID_RSA
        CONTAINER_DEMO_ID_RSA           = var.CONTAINER_DEMO_ID_RSA
      }
    )
  )
  ssh_keys = [data.hcloud_ssh_key.default.name]
}

data "hcloud_ssh_key" "default" {
  name = var.ssh_key.name
}
