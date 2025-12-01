variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "subnets" {
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
  }))
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
}
