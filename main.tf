#create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

#setup subnets using for_each to iterate over the map variable
resource "aws_subnet" "subnets" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = {
    Name = "${each.value.cidr_block}-${each.value.availability_zone}"
  }
}

#Attach an Internet Gateway (IGW) to the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
  
}

#Create a route table for the VPC and add a route to the IGW
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id   
    route {
          cidr_block = "0.0.0.0/0"
          gateway_id = aws_internet_gateway.igw.id
    }    
    tags = {
        Name = "${var.vpc_name}-public-rt"
    }
}

#Associate the public route table with the public subnets
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.subnets["subnet-a"].id
  route_table_id = aws_route_table.public_rt.id
}

# resource "aws_instance" "servers" {
#     for_each      = var.instances
#     ami           = each.value.ami
#     instance_type = each.value.instance_type
#     subnet_id     = aws_subnet.subnets["subnet-a"].id
#     key_name      = "pkawsprod"

#     tags = {
#         Name = each.key
#     }
# }

# output "instance_names" {
#   value = [for instance in aws_instance.servers : instance.tags.Name]
# }

data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]   
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.existing.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  #  Allows SSH from anywhere (use with caution)
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  #  Allows HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # 👈 Allows all outbound traffic
  }

  tags = {
    Name = "WebDMZ"
  }
}

resource "aws_instance" "web" {
  ami                         = "ami-052064a798f08f0d3"   
  instance_type              = "t3.micro"
  subnet_id                  = aws_subnet.subnets["subnet-a"].id
  key_name                   = "pkawsprod"             
  vpc_security_group_ids     = [aws_security_group.web_sg.id]  

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              cd /var/www/html
              echo '<html><h1>Hello AWS EC2 Instance!</h1></html>' > index.html
              EOF

  tags = {
    Name = "web01"
  }
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}