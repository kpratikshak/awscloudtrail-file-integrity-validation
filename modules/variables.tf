variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "trail_name" {
  description = "CloudTrail name"
  default     = "secure-cloudtrail"
}

variable "bucket_name" {
  description = "S3 bucket name for CloudTrail logs"
  type        = string
}
