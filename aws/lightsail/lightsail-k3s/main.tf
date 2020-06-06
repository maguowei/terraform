provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-1"
}

resource "aws_lightsail_key_pair" "k3s_key_pair" {
  name       = "k3s_key_pair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_lightsail_instance" "k3s" {
  name              = "k3s"
  availability_zone = "ap-northeast-1a"
  blueprint_id      = "ubuntu_18_04"
  bundle_id         = "small_2_0"
  key_pair_name     = "k3s_key_pair"
  user_data         = "curl -sfL https://get.k3s.io | sh -"
  tags = {
    app = "k3s"
  }
}
