resource "aws_instance" "servers" {
  for_each = var.instances

  ami           = each.value.ami
  instance_type = each.value.instance_type

  # Subnet passed from root module
  subnet_id = var.subnet_ids[each.value.subnet_key]

  # SGs passed from root module
  vpc_security_group_ids = [
    var.security_group_ids[each.value.sg_key]
  ]

  key_name = each.value.key_name

  user_data_base64 = base64encode(each.value.user_data)

  tags = {
    Name = each.key
  }
}
