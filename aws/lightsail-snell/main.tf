provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-1"
}

resource "aws_lightsail_key_pair" "my_key_pair" {
  name       = "my_key_pair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_lightsail_instance" "ubuntu" {
  name              = "shell"
  availability_zone = "ap-northeast-1a"
  blueprint_id      = "ubuntu_18_04"
  bundle_id         = "nano_2_0"
  key_pair_name     = "my_key_pair"
  user_data         = "curl -fsSL https://get.docker.com/ | sh; sudo usermod -aG docker ubuntu"
  tags = {
    app = "shell"
  }
}

output "aws_lightsail_instance_ip_addrs" {
  value = aws_lightsail_instance.ubuntu.public_ip_address
}
