###################### EBS Volume ######################
# resource "aws_ebs_volume" "terraform_ebs" {
#   availability_zone = "us-east-1a"
#   size              = 10

#   tags = {
#     Name = "HelloWorld"
#   }
# }

######################   EC2 creation ######################
# resource "aws_instance" "Hello" {
#   ami                         = "ami-0e2c8caa4b6378d8c"
#   instance_type               = "t2.micro"
#   associate_public_ip_address = true
#   key_name                    = "AWSDEMO"
#   security_groups             = ["allow_mtls"]

#   tags = {
#     Name = "Hello World"
#   }
# }


###################### Security group creation  ######################

# resource "aws_security_group" "allow_tls" {
#   name        = "allow_mtls"
#   description = "Allow TLS inbound traffic"
#   #   vpc_id      = aws_vpc.main.id

#   ingress {
#     description = "TLS from VPC"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     description = "TLS from VPC"
#     from_port   = 80
#     to_port     = 85
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "allow_tls"
#   }
# }








