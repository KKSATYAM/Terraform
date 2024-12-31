##################### Security group creation  ######################

resource "aws_security_group" "allow_tls" {
  name        = "sec grp"
  description = "Allow TLS inbound traffic"
  #   vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 85
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

#####################   EC2 creation ######################
resource "aws_instance" "Hello_Nginx" {
  ami                         = "ami-0e2c8caa4b6378d8c"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "AWSDEMO"
  security_groups             = ["sec grp"]

  tags = {
    Name = "Hello_Nginx"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("AWSDEMO.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install nginx -y"
    ]
  }





}

output "instance_ip_addr" {
  value = aws_instance.Hello_Nginx.public_ip
}

