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
  }))
  default = {
    subnet-a = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    }
    subnet-b = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    }
  }
}

