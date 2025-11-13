resource "aws_instance" "servers" {
  for_each = var.instances

  ami           = each.value.ami
  instance_type = each.value.instance_type
  subnet_id     = lookup(var.subnets, each.value.subnet_key)
  key_name      = each.value.key_name

  vpc_security_group_ids = [
    lookup({
      web_sg = var.web_sg_id
      db_sg  = var.db_sg_id
    }, each.value.sg_key)
  ]

  user_data_base64 = base64encode(each.value.user_data)

  tags = {
    Name = each.key
  }
}
