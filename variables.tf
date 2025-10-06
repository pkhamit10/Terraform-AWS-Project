variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "pk-vpc"
}

variable "subnets" {
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
  }))
  default = {
    subnet-a = {
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = true
    }
    subnet-b = {
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "us-east-1b"
      map_public_ip_on_launch = false
    }
  }
}
variable "instances" {
  type = map(object({
    ami           = string
    instance_type = string
    subnet_key    = string
    key_name      = string
    user_data     = string
    sg_key        = string
  }))
  default = {
    web_server = {
      ami           = "ami-052064a798f08f0d3"
      instance_type = "t3.micro"
      subnet_key    = "subnet-a"
      key_name      = "pkawsprod"
      user_data     = <<-EOF
                      #!/bin/bash
                      yum update -y
                      yum install httpd -y
                      systemctl start httpd
                      systemctl enable httpd
                      echo '<html><h1>Hello AWS EC2 Instance!</h1></html>' > /var/www/html/index.html
                      EOF
      sg_key        = "web_sg"
    }

    db_server = {
      ami           = "ami-052064a798f08f0d3"
      instance_type = "t3.micro"
      subnet_key    = "subnet-b"
      key_name      = "pkawsprod"
      user_data     = ""
      sg_key        = "db_sg"
    }
  }
}
