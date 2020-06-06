provider "aws" {
  region = "ap-east-1"
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my_key_pair"
  public_key = file("~/.ssh/id_rsa.pub")
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.nano"
  key_name      = aws_key_pair.my_key_pair.id
  tags = {
    app = "ubuntu"
  }

  user_data = <<EOF
#!/bin/bash
curl -fsSL https://get.docker.com/ | sh
sudo usermod -aG docker ubuntu
docker run --name surge-snell -d --restart always -p 1984:1984 maguowei/surge-snell fuckgfw
EOF

#   provisioner "remote-exec" {
#     connection {
#       host        = coalesce(self.public_ip, self.private_ip)
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = file("~/.ssh/id_rsa")
#     }

#     inline = [
#       "curl -fsSL https://get.docker.com/ | sh",
#       "sudo usermod -aG docker ubuntu",
#       "docker run --name surge-snell -d --restart always -p 1984:1984 maguowei/surge-snell fuckgfw",
#     ]
#   }
}

output "aws_instance" {
  value = {
    public_ip : aws_instance.ubuntu.public_ip
    public_dns : aws_instance.ubuntu.public_dns
    private_ip : aws_instance.ubuntu.private_ip
    private_dns : aws_instance.ubuntu.private_dns
    instance_state : aws_instance.ubuntu.instance_state
  }
}