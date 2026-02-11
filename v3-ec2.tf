 provider "aws" {
region  = "us-east-1"
}
 resource "aws_instance" "web" {
  for_each = {
    "J-M" = "t2.medium"
    "J-S" = "t2.large"
    "AS"  = "t2.micro"
  }
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = each.value
  key_name      = "sn"
  //security_groups = ["demo-sg"]     
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  subnet_id     = aws_subnet.d-subnet-1.id
  tags = {
    Name = each.key
  }
  }
resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH Access"
  vpc_id      = aws_vpc.d-vpc.id

  ingress {
    description      = "Shh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-prot"

  }
}

resource "aws_vpc" "d-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "d-vpc"
  }
}
resource "aws_subnet" "d-subnet-1" {
  vpc_id            = aws_vpc.d-vpc.id
  cidr_block        = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
    tags = {
        Name = "d-subnet-1"
    }
}

resource "aws_subnet" "d-subnet-2" {
  vpc_id            = aws_vpc.d-vpc.id
  cidr_block        = "10.1.2.0/24"
  map_public_ip_on_launch = true   
    availability_zone = "us-east-1b"
        tags = {
            Name = "d-subnet-2"
        }
}
resource "aws_internet_gateway" "d-igw" {
  vpc_id = aws_vpc.d-vpc.id
    tags = {
        Name = "d-igw"
    }
}
resource "aws_route_table" "d-rt" {
  vpc_id = aws_vpc.d-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.d-igw.id
    }
    tags = {
        Name = "d-rt"
    }
}
resource "aws_route_table_association" "a-rt-subnet-1" {
  subnet_id      = aws_subnet.d-subnet-1.id
  route_table_id = aws_route_table.d-rt.id
}
resource "aws_route_table_association" "a-rt-subnet-2" {
  subnet_id      = aws_subnet.d-subnet-2.id
  route_table_id = aws_route_table.d-rt.id
}

  module "sgs" {
    source = "../sg_eks"
    vpc_id     =     aws_vpc.d-vpc.id
 }

  module "eks" {
       source = "../eks"
       vpc_id     =     aws_vpc.d-vpc.id
       subnet_ids = [aws_subnet.d-subnet-1.id,aws_subnet.d-subnet-2.id]
       sg_ids = module.sgs.security_group_public
 }