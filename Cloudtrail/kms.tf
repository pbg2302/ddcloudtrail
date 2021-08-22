data "aws_caller_identity" "kmscurrent" {}
resource "aws_kms_key" "cloudtrail_key" {
  deletion_window_in_days = 7
  description             = "CloudTrail Log Encryption Key"
  enable_key_rotation     = true
   policy = <<POLICY
   {
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.kmscurrent.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow access for Key Administrators",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.kmscurrent.account_id}:user/${var.user_name}"
            },
            "Action": [
                "kms:Create*",
                "kms:Describe*",
                "kms:Enable*",
                "kms:List*",
                "kms:Put*",
                "kms:Update*",
                "kms:Revoke*",
                "kms:Disable*",
                "kms:Get*",
                "kms:Delete*",
                "kms:TagResource",
                "kms:UntagResource",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow CloudTrail to encrypt logs",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "kms:GenerateDataKey*",
            "Resource": "*",
            "Condition": {
              "StringLike": {
                "kms:EncryptionContext:aws:cloudtrail:arn": [
                  "arn:aws:cloudtrail:*:${data.aws_caller_identity.kmscurrent.account_id}:trail/*"
                ]
              }
            }
        },
        {
            "Sid": "Enable CloudTrail log decrypt permissions",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::${data.aws_caller_identity.kmscurrent.account_id}:user/${var.user_name}"
            },
            "Action": "kms:Decrypt",
            "Resource": "*",
            "Condition": {
              "Null": {
                "kms:EncryptionContext:aws:cloudtrail:arn": "false"
              }
            }
          },
          {
            "Sid": "Allow CloudTrail access",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "kms:DescribeKey",
            "Resource": "*"
          }
        
    ]
}
POLICY
}