provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-1"
}

resource "aws_lightsail_key_pair" "my_key_pair" {
  name       = "my_key_pair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_lightsail_instance" "k8s" {
  count = 2

  name              = "k8s-${count.index}"
  availability_zone = "ap-northeast-1a"
  blueprint_id      = "ubuntu_18_04"
  bundle_id         = "medium_2_0"
  key_pair_name     = "my_key_pair"
  user_data         = "curl -fsSL https://get.docker.com/ | sh; sudo usermod -aG docker ubuntu"
  tags = {
    app = "k8s"
  }
}

output "aws_lightsail_instance_ip_addrs" {
  # value = aws_lightsail_instance.k8s[*].public_ip_address
  value = {for k, k8s in aws_lightsail_instance.k8s[*] : k => k8s.public_ip_address}
}