output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.urlshortner.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_eip.urlshortner_eip.public_ip
}

output "public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.urlshortner.public_dns
}

output "app_url" {
  description = "Application URL"
  value       = "http://${aws_eip.urlshortner_eip.public_ip}:8080"
}

output "ssh_command" {
  description = "SSH command to connect to EC2"
  value       = "ssh ec2-user@${aws_eip.urlshortner_eip.public_ip}"
}