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

# variable "subnet_name" {
#   description = "The name of the subnet"
#   type        = string
#   default     = "10.0.1.0/24 - us-east-1a"
# }

# variable "subnet_cidr" {
#   description = "The CIDR block for the subnet"
#   type        = string
#   default     = "10.0.1.0/24"
# }

# variable "subnet_az" {
#   description = "The availability zone for the subnet"
#   type        = string
#   default     = "us-east-1a"
# }

variable "subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
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

# variable "instances" {
#   type = map(object({
#     ami           = string
#     instance_type = string
#   }))
#   default = {
#     web01 = {
#       ami           = "ami-052064a798f08f0d3" # Amazon Linux 2 AMI
#       instance_type = "t3.micro"
#     }
#     dbserver = {
#       ami           = "ami-0360c520857e3138f" # Amazon Linux 2 AMI
#       instance_type = "t3.micro"
#     }
#   } 
#}