# -------------------------
# Create VPC
# -------------------------
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

# -------------------------
# Create Subnets
# -------------------------
resource "aws_subnet" "subnets" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = {
    Name = "${var.vpc_name}-${each.key}"
  }
}

# -------------------------
# Internet Gateway
# -------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# -------------------------
# Elastic IP for NAT Gateway
# -------------------------
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "nat-eip"
  }
}

# -------------------------
# NAT Gateway in Public Subnet
# -------------------------
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnets["subnet-a"].id
  tags = {
    Name = "nat-gateway"
  }
  depends_on = [aws_internet_gateway.igw]
}

# -------------------------
# Public Route Table
# -------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

# -------------------------
# Associate Public Subnet
# -------------------------
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.subnets["subnet-a"].id
  route_table_id = aws_route_table.public_rt.id
}

# -------------------------
# Add NAT Route to Main Route Table
# -------------------------
resource "aws_route" "nat_route" {
  route_table_id         = aws_vpc.this.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

