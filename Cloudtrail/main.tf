
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
    
    region = var.region
    profile = "default"
    
}

resource "aws_cloudtrail" "dd_aws_cloud_trail" {
  
  name = var.cloudtrail_name
  s3_bucket_name = aws_s3_bucket.dd_aws_bucket_name.id
  s3_key_prefix  = "prefix"
  enable_logging = true
  kms_key_id = aws_kms_key.cloudtrail_key.arn
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.dd_cloud_watch_log_group.arn}:*"
  cloud_watch_logs_role_arn = aws_iam_role.dd_cloudwatch_role.arn
  include_global_service_events = true
  enable_log_file_validation = true
  is_multi_region_trail = true

}