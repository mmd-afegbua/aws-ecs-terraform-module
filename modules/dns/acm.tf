resource "aws_acm_certificate" "acm_certificate" {
  provider = aws.current
  domain_name               = var.domain_name
  validation_method         = "DNS"
  tags = {
    Environment = var.environment
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "acm_certificate_validation" {
    provider = aws.current
    certificate_arn = aws_acm_certificate.acm_certificate.arn
    validation_record_fqdns = [ "aws_route53_record.validation_route53_record.*.fqdn" ]
}