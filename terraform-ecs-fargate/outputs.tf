output "strapi_url" {
  description = "Public URL to access Strapi"
  value       = aws_lb.strapi_alb.dns_name
}
