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

variable "subnets" {
  description = "Map of subnet keys to subnet IDs"
  type        = map(string)
}

variable "web_sg_id" {
  type = string
}

variable "db_sg_id" {
  type = string
}
