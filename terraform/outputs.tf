output "instance_id" {
  description = "The ID of the AWS EC2 instance"
  value       = aws_instance.ubuntu_instance.id
}

output "instance_public_ip" {
  description = "The public IP of the AWS EC2 instance"
  value       = aws_instance.ubuntu_instance.public_ip
}
