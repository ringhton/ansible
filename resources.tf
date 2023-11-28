resource "digitalocean_ssh_key" "my_key" { 
  name       = "dig_oc_key_1"
  public_key = file(var.my_key)
}

resource "digitalocean_droplet" "do_devops" {
  name   = "digital-ocean-terraform-ansible"
  tags	 = [var.tag1,var.tag2]
  size   = "s-1vcpu-1gb"
  image  = "ubuntu-22-04-x64"
  region = var.reg_do
  ssh_keys = [digitalocean_ssh_key.my_key.fingerprint,data.digitalocean_ssh_key.rebrain_key.fingerprint]
}

resource "local_file" "ansible_inventory" {
  content  =	templatefile("ansible.tftpl",{
      ansible_connection = "ssh"
      ansible_host = digitalocean_droplet.do_devops.ipv4_address
      ansible_port = 22
      ansible_user = var.user
      ansible_ssh_private_key_file = file(var.priv_key)
      })
  filename = "${path.module}/inventory.yaml"
}
