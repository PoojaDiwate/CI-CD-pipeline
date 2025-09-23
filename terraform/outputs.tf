output "strapi_public_ip" {
  description = "Public IP of Strapi EC2 instance"
  value       = aws_instance.strapi_server.public_ip
}
