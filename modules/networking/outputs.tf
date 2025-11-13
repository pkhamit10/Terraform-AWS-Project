output "vpc_id" {
  value = aws_vpc.this.id   
}
output "subnet_ids" {
  value = [for subnet in aws_subnet.subnets : subnet.id]
}
output "igw_id" {
  value = aws_internet_gateway.igw.id   
}
output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}
output "public_route_table_id" {
  value = aws_route_table.public_rt.id
}
output "nat_eip" {
  value = aws_eip.nat_eip.public_ip
}