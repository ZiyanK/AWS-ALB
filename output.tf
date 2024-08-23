output "aws_lb_dns_name" {
  description = "DNS URL of the ALB created on AWS"
  value       = aws_lb.test.dns_name
}