variable "cloudtrail_name" {
  description = "cloudtrail name"
  type        = string
}

variable "region" {
  description = "region"
  default = "eu-west-2"
  type        = string
}


 variable "user_name" {
   description = "user name to pass on for KMS"
   type        = string
 }

variable "log_group_name" {
  description = "Cloud watch log group name"
  type        = string
}

variable "bucket_name" {
  description = "s3 bucket name"
  type        = string
}


variable "cloudwatch_role_name" {
  description = "cloudwatch role name"
  type        = string
}

variable "policy_name" {
  description = "cloudwatch policy name"
  type        = string
}

variable "dd_alarm_name" {
  description = "DD alaram name"
  type        = string
}


variable "dd_metric_name" {
  description = "DD metric name"
  type        = string
}

variable "dd_namespace" {
  description = "DD namespace name"
  type        = string
}

variable "dd_alarm_description" {
  description = "DD alarm description name"
  type        = string
}

variable "dd_alarm_actions" {
  description = "DD alaram action should be the arn of sns topic"
  type        = string
}

variable "dd_ok_actions" {
  description = "DD ok alaram action should be the arn of sns topic"
  type        = string
}





