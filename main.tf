provider "aws" {
  region = "us-east-1"
}

  
locals {
  ssh_user         = "ubuntu"
  key_name         = "test"
  private_key_path = "test.pem"
}


resource "aws_instance" "nginx" {
  ami                         = "ami-0acd36292794047ab"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = local.key_name

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.nginx.public_ip
    }
  }
  resource "time_sleep" "wait_30_seconds" {
  depends_on = [aws_instance.nginx]

  create_duration = "500s"
}
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.nginx.public_ip}, --private-key ${local.private_key_path} nginx.yaml"
  }
}

output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}
