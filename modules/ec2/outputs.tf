output "web_instance_public_ip" {
  value = aws_instance.servers["web_server"].public_ip
}

output "db_instance_private_ip" {
  value = aws_instance.servers["db_server"].private_ip
}
