variable "instances" {
  type = map(object({
    ami           = string
    instance_type = string
    subnet_key    = string
    sg_key        = string
    key_name      = string
    user_data     = string
  }))
}

variable "subnet_ids" {
  type = map(string)
}

variable "security_group_ids" {
  type = map(string)
}
