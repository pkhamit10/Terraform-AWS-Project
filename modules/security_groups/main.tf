# -------------------------
# Security Group for Web Server
# -------------------------

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = var.vpc_id

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
# # -------------------------
# # Security Group for DB Server
# # -------------------------
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  vpc_id      = var.vpc_id
  description = "Security group for database server"

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