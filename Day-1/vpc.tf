
######################   VPC creation ######################
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "VPC_THROUGH_TERRAFORM"
  }
}

######################   Internet Gateway creation ######################
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "INTERNET_GATEWAY"
  }
}

######################   Subnet creation ######################
resource "aws_subnet" "my_public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "PUBLIC_SUBNET"
  }
}

######################   Subnet creation ######################
resource "aws_subnet" "my_private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "PRIVATE_SUBNET"
  }
}


######################   Route Table creation ######################
resource "aws_route_table" "my_route_table_internet" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "CONNECTED_TO_INTERNET"
  }
}

######################   Route Table creation ######################
resource "aws_route_table" "my_route_table_with_no_internet" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "NOT_CONNECTED_TO_INTERNET"
  }
}

######################   Route Table Assocation ######################
resource "aws_route_table_association" "PUBLIC_SUBNET_TABLE" {
  subnet_id      = aws_subnet.my_public_subnet.id
  route_table_id = aws_route_table.my_route_table_internet.id
}

resource "aws_route_table_association" "PRIVATE_SUBNET_TABLE" {
  subnet_id      = aws_subnet.my_private_subnet.id
  route_table_id = aws_route_table.my_route_table_with_no_internet.id
}


######################   Key Pair creation ######################
resource "aws_key_pair" "key_pair" {
  key_name   = "my_personal_key_31_12_2024"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEaUT8UZx69yZwPOiQnkpWVNbV+NIWQqsCx9n5HxsXYu satya@Cognizant"
}

###################### Security group creation  ######################

resource "aws_security_group" "my_firewall" {
  name        = "allow_mtls"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "allow https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #   ingress {
  #     description = "allow icmp"
  #     from_port   = -1
  #     to_port     = -1
  #     protocol    = "icmp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALLOW_HTTPS_AND_HTTP_SSH"
  }
}

######################   EC2 creation ######################

resource "aws_instance" "public_instance" {
  ami                         = "ami-0e2c8caa4b6378d8c"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.my_public_subnet.id
  key_name                    = aws_key_pair.key_pair.key_name
  security_groups             = [aws_security_group.my_firewall.id]


  tags = {
    Name = "EC2_PUBLIC"
  }
}

######################   EC2 creation ######################

resource "aws_instance" "private_instance" {
  ami                         = "ami-0e2c8caa4b6378d8c"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.my_private_subnet.id
  key_name                    = aws_key_pair.key_pair.key_name
  security_groups             = [aws_security_group.my_firewall.id]


  tags = {
    Name = "EC2_PRIVATE"
  }
}
