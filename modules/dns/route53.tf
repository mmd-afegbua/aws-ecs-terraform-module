resource "aws_route53_record" "validation_route53_record" {
  provider = aws.current
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.record_ttl
  type            = each.value.type
  zone_id         = var.zone_id
}  