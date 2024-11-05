# Output the instance ID
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.stocks_trading_robot_instance.id
}

# Output the public IP address
output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.stocks_trading_robot_instance.public_ip
}