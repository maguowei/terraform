variable "ec2_node_num" {
  type    = number
  default = 3
}

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
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_spot_instance_request" "ubuntu" {
  count         = var.ec2_node_num
  ami           = data.aws_ami.ubuntu.id
  spot_price    = "0.03"
  instance_type = "t3.medium"
  key_name      = aws_key_pair.my_key_pair.id
  tags = {
    app = "ubuntu"
  }
}

output "aws_instance_public_ip" {
  value = { for k, ubuntu in aws_spot_instance_request.ubuntu[*] : k => ubuntu.public_ip }
}
output "aws_instance_public_dns" {
  value = { for k, ubuntu in aws_spot_instance_request.ubuntu[*] : k => ubuntu.public_dns }
}
output "aws_instance_private_ip" {
  value = { for k, ubuntu in aws_spot_instance_request.ubuntu[*] : k => ubuntu.private_ip }
}
output "aws_instance_private_dns" {
  value = { for k, ubuntu in aws_spot_instance_request.ubuntu[*] : k => ubuntu.private_dns }
}
output "aws_instance_instance_state" {
  value = { for k, ubuntu in aws_spot_instance_request.ubuntu[*] : k => ubuntu.instance_state }
}
