provider "aws" {
  region = "ap-south-1" # Mumbai
}

resource "aws_security_group" "nginx_sg" {
  name = "nginx-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx_server" {
  ami                    = "ami-03f4878755434977f" # Ubuntu 22.04 Mumbai
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install nginx -y
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Terraform NGINX Server</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "Terraform-Nginx-Server"
  }
}

output "public_ip" {
  value = aws_instance.nginx_server.public_ip
}