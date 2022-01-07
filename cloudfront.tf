# Redirect to www
resource "aws_cloudfront_distribution" "root_distribution" {
  origin {
    domain_name = "${var.domain_name}.s3-website-us-east-1.amazonaws.com"
    origin_id = "s3-.${var.bucket_name}"
    s3_origin_config {
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled = true
  is_ipv6_enabled = true

  aliases = [var.domain_name]

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "s3-.${var.bucket_name}"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn
    minimum_protocol_version = "TLSv1.1_2016"
  }
}

# Cloudfront distribution for main s3 site.
resource "aws_cloudfront_distribution" "www_distribution" {
  origin {
    domain_name = aws_s3_bucket.www_bucket.website_endpoint
    origin_id = "S3-www.${var.bucket_name}"

    s3_origin_config {
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"

  aliases = ["www.${var.domain_name}"]

  custom_error_response {
    error_caching_min_ttl = 0
    error_code = 404
    response_code = 200
    response_page_path = "/404.html"
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "S3-www.${var.bucket_name}"

    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn
    minimum_protocol_version = "TLSv1.1_2016"
  }
}
