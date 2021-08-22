data "aws_region" "current" {}

# The AWS account id
data "aws_caller_identity" "current" {
}

# The AWS partition (commercial or govcloud)
data "aws_partition" "current" {}
resource "aws_iam_role" "dd_cloudwatch_role" {

    name               = var.cloudwatch_role_name
    assume_role_policy = data.aws_iam_policy_document.cloudTrail_cloudwatch.json 
}

data "aws_iam_policy_document" "cloudTrail_cloudwatch" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudtrail_cloudwatch_logs" {
  statement {
    sid = "WriteCloudWatchLogs"

    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.log_group_name}:*"]
    
  }
}

resource "aws_iam_policy" "cloudtrail_cloudwatch_logs" {
  name = var.policy_name
  policy = data.aws_iam_policy_document.cloudtrail_cloudwatch_logs.json
}

resource "aws_iam_policy_attachment" "cloudtrail_cloudwatch_policy_attachment" {
  name       = "cloudtrail-cloudwatch-logs-policy-attachment"
  policy_arn = aws_iam_policy.cloudtrail_cloudwatch_logs.arn
  roles         =      [aws_iam_role.dd_cloudwatch_role.name]
}

