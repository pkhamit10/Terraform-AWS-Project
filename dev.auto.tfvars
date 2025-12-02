# -----------------------
# VPC CONFIG (DEV)
# -----------------------
vpc_cidr = "10.10.0.0/16"
vpc_name = "dev-vpc"

# -----------------------
# SUBNETS (DEV)
# -----------------------
subnets = {
  subnet-a = {
    cidr_block              = "10.10.1.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
  }
  subnet-b = {
    cidr_block              = "10.10.2.0/24"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = false
  }
}

# -----------------------
# EC2 INSTANCES FOR DEV
# -----------------------
instances = {
  web_server = {
    ami           = "ami-0c02fb55956c7d316" # example dev AMI
    instance_type = "t3.micro"
    subnet_key    = "subnet-a"
    key_name      = "pkawsprod"
    user_data     = <<-EOF
                      #!/bin/bash
                      yum update -y
                      yum install httpd -y
                      systemctl enable httpd
                      systemctl start httpd
                      echo "<h1>Dev Web Server</h1>" > /var/www/html/index.html
                    EOF
    sg_key        = "web_sg"
  }

  db_server = {
    ami           = "ami-0c02fb55956c7d316"
    instance_type = "t3.micro"
    subnet_key    = "subnet-b"
    key_name      = "pkawsprod"
    user_data     = ""
    sg_key        = "db_sg"
  }
}
