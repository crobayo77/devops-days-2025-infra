resource "aws_s3_bucket" "devops-days-prod" {
  bucket        = "frontend-devops-medellin-prod"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "s3-fbd-block-prod" {
  bucket                  = aws_s3_bucket.devops-days-prod.id
  ignore_public_acls      = true
  block_public_policy     = true
  block_public_acls       = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket     = aws_s3_bucket.devops-days-prod.id
  policy     = data.aws_iam_policy_document.s3_bucket_policy.json
  depends_on = [aws_s3_bucket_public_access_block.s3-fbd-block-prod]
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  policy_id = "PolicyForCloudFrontPrivateContent"
  version   = "2008-10-17"
  statement {
    sid     = "AllowCloudFrontServicePrincipal"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    resources = [
      "${aws_s3_bucket.devops-days-prod.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [aws_cloudfront_distribution.frontend_distribution_prod.arn]
    }

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
  }
}
