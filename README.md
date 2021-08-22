### Overview 

The purpose of this document is provide IAC on how to:
- enable cloudtrail in all region 
- create cloudwatch filters and notify
- delete the default vpc in all aws regions 

### Purpose
CloudTrail provides a continuous audit log of changes to AWS resources within each AWS account, including actions taken through the AWS Management Console, AWS SDKs, command line tools, and other AWS services. This event history can be used for audit, compliance, or security analysis purposes.

Terraform code provision an s3 bucket with all public access to the bucket blocked, s3 bucket access logging is enabled. This bucket is used to store cloudtrail logs.

The IAC also provision an aws cloudtrail in all region with log file validation enabled, management and global events captured within the cloudtrail. Cloudtrail logs are encrypted at rest using KMS Managed CMKS and aslo creates a cloudwatch log group to intergrate cloudtrail logs with cloudwatch logs.

Third, The IAC creates cloudwatch mertic filter and creates alarms to notify the customers whenever below events are logged in cloudtrail.
- Unauthorized API calls
- Management Console sign-in without MFA
- Usage of the "root" account

### Input Variables
The folloing variuables are used within the IAC.

- `region` - Name of the region where the trail should be created (default: eu-west-2)
- `s3_bucket_name` - Name of the S3 bucket to store logs in (required)
- `s3_key_prefix` - Specifies the S3 key prefix that precedes the name of the bucket you have designated for log file delivery
- `enable_logging` - Specifies whether to enable logging for the trail (default: true)
- `include_global_service_events` - Specifies whether the trail is publishing events from global services such as IAM (default: true)
- `is_multi_region_trail` - Specifies whether the trail is created in the current region or in all regions (default: true)
- `enable_log_file_validation` - Specifies whether log file integrity validation is enabled (default: true)
- `kms_key_id` - Specifies the KMS key ARN to use to encrypt the logs delivered by CloudTrail.
- `cloud_watch_logs_role_arn` - Specifies the role for the CloudWatch Logs endpoint to assume to write to a user’s log group.
- `cloud_watch_logs_group_arn` - Specifies a log group name using an Amazon Resource Name (ARN), that represents the log group to which CloudTrail logs will be delivered.
- `cloudtrail_name` - Name of the cloudtrail
- `log_group_name`  - Name of the cloudwatch log group name to integrate cloudtrail trails.
- `cloudwatch_role_name` - Name for the CloudTrail IAM role
- `policy_name` - Name of policy 
- `dd_alarm_name` - The descriptive name for the alarm. This name must be unique within the user's AWS account
- `dd_metric_name` - The name for the alarm's associated metric. See docs for supported metrics.
- `dd_namespace` - The destination namespace of the CloudWatch metric.
- `dd_alarm_description` - The description for the alarm.
- `dd_alarm_actions` - The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Name (ARN).
- `dd_ok_actions` - The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Name.
- `user_name` - Username for the KMS Key Administrators.

# NOTE: 
Please have your aws profile configured locally on the host. IAC make use of the profile creds for resources creation.

To notify the customer using the alarms it uses an already created sns topic which is passed on the to variable `dd_alarm_actions` and `dd_ok_actions` for notifucation.

As the IAc is using lots of varibles, it is more convenient to to specify their values in a variable definitions file and then specify that file on the command line. In this case
I have used the file name as `dev.tfvars`.

`terraform apply -var-file="dev.tfvars"`

### Requirements
 - Terraform >=0.13
 - AWS       >=2.0
 - Valid AWS API keys/profile(configured AWS profile locally on host)

## Usage


- terraform apply -var-file="dev.tfvars"

### Outputs
- `id` - The name of the trail.
- `arn` - The Amazon Resource Name of the trail.

### Removing Default VPCs Requirements

Each new AWS account contains new default network resources within each region. As the default subnets provide access to the internet, there is a risk that workloads could be deployed directly onto these subnets and bypass the network controls in place within the platform that prevent uncontrolled access to the internet. To mitigate this risk, the default VPC and all of the associated default network resources in every region must be deleted from the account.
Python script will delete ALL default resources in every default VPC in every AWS region. 

## Requirements:
Tested with:
- Python version: >= 3.7.0
- Boto3 version: >= 1.7.50
- Valid AWS API keys/profile(configured AWS profile locally on host)

## Usage:
python  deletedefaultvpc.py

