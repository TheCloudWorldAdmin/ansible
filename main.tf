provider "aws" {
  region = "us-east-1"
}

locals {
  ssh_user         = "ec2-user"
  key_name         = "key"
  private_key_path = "key.pem"
}

resource "aws_instance" "nginx" {
  ami                         = "ami-0c2b8ca1dad447f8a"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = local.key_name

  # provisioner "remote-exec" {
  #   inline = ["echo 'Wait until SSH is ready'"]

 
  # }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.nginx.public_ip}, --private-key key.pem nginx.yaml"
  }
}

output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}