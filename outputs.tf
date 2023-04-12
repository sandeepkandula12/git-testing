output "private_ips" {
  description = "List of private IP addresses assigned to the DB and APP instances"
  value       = [aws_instance.web.*.private_ip]
}
output "public_ips" {
  description = "List of public IP addresses assigned to the DB and APP instances"
  value       = [aws_instance.web.*.public_ip]
}

