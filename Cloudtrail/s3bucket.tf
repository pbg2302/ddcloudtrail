data "aws_caller_identity" "s3current" {}

resource "aws_s3_bucket" "bddlogging" {
  bucket = "ddlogging"
  acl    = "log-delivery-write"
}
resource "aws_s3_bucket" "dd_aws_bucket_name" {
  bucket = var.bucket_name
  acl    = "private"
  force_destroy = true
  logging {
    target_bucket = aws_s3_bucket.bddlogging.id
    target_prefix = "log/"
  }
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.bucket_name}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.bucket_name}/prefix/AWSLogs/${data.aws_caller_identity.s3current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
resource "aws_s3_bucket_public_access_block" "ddblocks3" {
  bucket = aws_s3_bucket.dd_aws_bucket_name.id

  block_public_acls   = true
  block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls = true
}

resource "aws_s3_bucket_public_access_block" "ddblocks4" {
  bucket = aws_s3_bucket.bddlogging.id

  block_public_acls   = true
  block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls = true
}
