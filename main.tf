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
  subnet_id      = aws_subnet.subnets["subnet1"].id
  route_table_id = aws_route_table.public_rt.id
}