# Path: infrastructure/terraform/aws/outputs.tf

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "backend_url" {
  value = "http://${aws_lb.main.dns_name}:8000"
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.frontend.domain_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.frontend.id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.backend.repository_url
}
