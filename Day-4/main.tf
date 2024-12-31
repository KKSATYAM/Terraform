#####################   EC2 creation ######################
resource "aws_instance" "Hello_Nginx" {
  ami                         = "ami-0e2c8caa4b6378d8c"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "AWSDEMO"
  #   security_groups             = ["allow_traffic"]


  tags = {
    Name = "Hello_Nginx"
  }

}

#################### EBS Volume ####################
# resource "aws_ebs_volume" "ebs_vol" {

#   depends_on        = [aws_instance.Hello_Nginx]
#   availability_zone = "us-east-1a"

#   size = 10
#   tags = {
#     Name = "Hello_Nginx"
#   }
# }

#################### Elastic IP ####################
resource "aws_eip" "elastic_ip" {

  #   depends_on = [aws_instance.Hello_Nginx]
  instance = aws_instance.Hello_Nginx.id
  #   vpc        = true
  tags = {
    Name = "Hello_Nginx"
  }

}
