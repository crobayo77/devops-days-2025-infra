locals {
  s3_origin_id_prod = "devops-days-origin-prod"
}

resource "aws_cloudfront_origin_access_control" "this" {

  name                              = "Origin Access Control for DevOps Medellin"
  description                       = "Origin Access Control for DevOps Medellin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "frontend_distribution_prod" {
  origin {
    domain_name = aws_s3_bucket.devops-days-prod.bucket_regional_domain_name
    origin_id   = local.s3_origin_id_prod

    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "DevOps Medellin Frontend Distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id_prod

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CO"]
    }
  }
  tags = {
    Name = "DevOps Medellin Frontend Distribution"
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}