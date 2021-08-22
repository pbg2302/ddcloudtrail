resource "aws_cloudwatch_log_group" "dd_cloud_watch_log_group" {

    name = var.log_group_name
    
}

resource "aws_cloudwatch_log_metric_filter" "ddlogfilter-AccessDenied" {
  name           = "AccessDenied"
  pattern        = "{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }"
  
  log_group_name = aws_cloudwatch_log_group.dd_cloud_watch_log_group.name

  metric_transformation {
    name      = "ErrorCount"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "ddlogfilter-ConsoleLogin" {
  name           = "ConsoleLogin"
  pattern        = "{ ($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") }"

  log_group_name = aws_cloudwatch_log_group.dd_cloud_watch_log_group.name

  metric_transformation {
    name      = "EventCount"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "ddlogfilter-root" {
  name           = "UserIdentity"

  pattern        = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"


  log_group_name = aws_cloudwatch_log_group.dd_cloud_watch_log_group.name

  metric_transformation {
    name      = "EventCount"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "ddalarm" {
  alarm_name          = var.dd_alarm_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = var.dd_metric_name
  namespace           = var.dd_namespace
  period              = "60"
  statistic           = "Average"
  alarm_description   = var.dd_alarm_description
  actions_enabled     = "true"
  alarm_actions       = [var.dd_ok_actions]
  ok_actions          = [var.dd_alarm_actions]
  
}

