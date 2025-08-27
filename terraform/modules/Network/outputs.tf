output "public_subnet_ids_list" {
  description = "List of public subnet IDs"
  value       = values(aws_subnet.public)[*].id
}

output "private_subnet_ids_list" {
  description = "List of private subnet IDs"
  value       = values(aws_subnet.private)[*].id
}

output "vpc" {
  value = aws_vpc.vpc.id
}