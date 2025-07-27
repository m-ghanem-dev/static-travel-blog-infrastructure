resource "aws_cloudfront_distribution" "cdn" {
  origin {
    // Use S3 static website endpoint as origin domain
    domain_name = "static-travel-blog-bucket-jskldjlq341.s3-website-us-east-1.amazonaws.com"
    origin_id   = "S3-static-travel-blog-bucket"

    custom_origin_config {
      // Ports CloudFront uses to connect to origin
      http_port              = 80
      https_port             = 443

      // CloudFront connects to origin over HTTP only (S3 website endpoint doesn’t support HTTPS)
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"] // Not used here, but required by schema
    }
  }

  enabled             = true       // Enable this distribution
  is_ipv6_enabled     = true       // Support IPv6 clients
  default_root_object = "index.html" // Default file to serve

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"] // Methods CloudFront accepts from viewers
    cached_methods   = ["GET", "HEAD"] // Methods CloudFront caches responses for
    target_origin_id = "S3-static-travel-blog-bucket" // Origin to forward requests to

    forwarded_values {
      query_string = false // Don’t forward query strings to origin (improves caching)

      cookies {
        forward = "none" // Don’t forward cookies to origin (improves caching)
      }
    }

    viewer_protocol_policy = "redirect-to-https" // Redirect HTTP requests from clients to HTTPS
    min_ttl                = 0      // Minimum TTL for cached objects
    default_ttl            = 3600   // Default TTL (1 hour) for cached objects
    max_ttl                = 86400  // Max TTL (1 day) for cached objects
  }

  price_class = "PriceClass_100" // Use lowest cost edge locations (US, Canada, Europe)

  viewer_certificate {
    cloudfront_default_certificate = true // Use default CloudFront SSL cert (*.cloudfront.net)
  }

  restrictions {
    geo_restriction {
      restriction_type = "none" // No geographic access restrictions
    }
  }
}
