server = {
  name  = "bamboo-agents"
  image = "ubuntu-22.04"
  # 16.18 euros per month
  type         = "cpx31"
  datacenter   = "hil-dc1"
  ipv4_enabled = true
  ipv6_enabled = false
}

# The ssh_key with name main have to be created beforehand in the hetzner account
ssh_key = {
  name = "main"
}

bamboo_agents = [
  {
    uuid          = "00000000-0000-1001-0000-000000000001"
    id            = "1001"
    name          = "cisa-agent01"
    docker_image  = "xalt/bamboo-agent:BLI-413"
    bamboo_server = "https://bamboo.xalt.team"
    ram_min       = 256
    ram_max       = 6144
    time_zone     = "Europe/Berlin"
  }
]
