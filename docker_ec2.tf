provider "aws" {
  region     = "us-east-1"  
}

resource "aws_instance" "instance__2" {
  ami           = "ami-0230bd60aa48260c6"  
  instance_type = "t2.micro"
  key_name      = "key"
  tags = {
    Name = "MyDocker"  
  }
  vpc_security_group_ids = [aws_security_group.instance__2.id]
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              sudo yum search docker
              sudo yum info docker
              sudo yum install docker -y 
              sudo usermod -a -G docker ec2-user
              id ec2-user
              newgrp docker
              wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) 
              sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
              sudo chmod -v +x /usr/local/bin/docker-compose
              sudo systemctl enable docker.service
              sudo systemctl start docker.service
              sudo systemctl status docker.service
              EOF
}

resource "aws_security_group" "instance__2" {
  name = "Name of VPC 2"
  description = "Description of VPC 2"
  ingress  {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress  {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress  {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port =  0
    to_port   =  0 
    protocol  = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {

  value = aws_instance.instance__2.public_ip
}