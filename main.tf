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

# -------------------------
# Security Group for Web Server
# -------------------------

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #  Allows SSH from anywhere (use with caution)
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #  Allows HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #  Allows all outbound traffic
  }

  tags = {
    Name = "WebDMZ"
  }
}
# -------------------------
# Security Group for DB Server
# -------------------------
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Security group for database server"
  vpc_id      = aws_vpc.my_vpc.id

  # Allow inbound traffic from your app/web servers (example: port 3306 for MySQL)
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id] # Only allow your web/app SG
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}
# -------------------------
# Create EC2 Instances dynamically
# -------------------------
resource "aws_instance" "servers" {
  for_each = var.instances

  ami           = each.value.ami
  instance_type = each.value.instance_type
  subnet_id     = aws_subnet.subnets[each.value.subnet_key].id
  key_name      = each.value.key_name
  vpc_security_group_ids = [lookup({
    web_sg = aws_security_group.web_sg.id
    db_sg  = aws_security_group.db_sg.id
  }, each.value.sg_key)]

  user_data_base64 = base64encode(each.value.user_data)

  tags = {
    Name = each.key
  }
}

# -------------------------
# Outputs
# -------------------------
output "web_instance_public_ip" {
  value = aws_instance.servers["web_server"].public_ip
}

output "db_instance_private_ip" {
  value = aws_instance.servers["db_server"].private_ip
}
# -------------------------
# Create NAT Gateway in public subnet
# -------------------------
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnets["subnet-a"].id
  tags = {
    Name = "nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]  # Make sure IGW exists first
}
# -------------------------
# Allocate Elastic IP for NAT Gateway
# -------------------------
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "nat-eip"
  }
}


# Add a route to the main route table via NAT Gateway
resource "aws_route" "nat_route" {
  route_table_id         = aws_vpc.my_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

