resource "aws_instance" "Hello_Nginx_1" {

  depends_on                  = [aws_security_group.allow_tls]
  ami                         = "ami-0e2c8caa4b6378d8c"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "AWSDEMO"
  security_groups             = ["allow_traffic"]


  tags = {
    Name = "Hello_Nginx_1"
  }


}

resource "aws_security_group" "allow_tls" {
  name        = "allow_traffic"
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

#################### NULL RESOURCE ####################
resource "null_resource" "null_job" {

  depends_on = [aws_instance.Hello_Nginx_1]

  #   triggers = {
  #     id = timestamp()
  #   }
  #   provisioner "local-exec" {
  #     command = "echo 'Hello, World!' >> b.txt"
  #   }

  #   provisioner "local-exec" {
  #     when    = destroy
  #     command = "echo 'Goodbye, World!' >> a.txt"

  #   }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("AWSDEMO.pem")
    host        = aws_instance.Hello_Nginx_1.public_ip
  }

  provisioner "file" {
    source      = "./main.tf"
    destination = "main.tf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
    ]

  }

}

resource "null_resource" "null_job_1" {

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("AWSDEMO.pem")
    host        = aws_instance.Hello_Nginx_1.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
    ]

  }
}
