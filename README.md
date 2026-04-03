#🔐 AWS CloudTrail Log File Integrity Validation

# 📌 Overview

This project demonstrates how to enable and verify log file integrity 
validation in AWS CloudTrail to ensure logs are not tampered with after creation.

Using this setup, security teams can cryptographically verify whether CloudTrail logs
have been modified, deleted, or altered.

🧠 Usage:
Tamper-proof audit logs
Compliance (SOC 2, ISO 27001, PCI-DSS)
Ability to validate log integrity for forensic analysis
🏗️ Architecture

User Activity → CloudTrail → S3 Bucket → Digest Files → Validation via CLI

⚙️ Prerequisites:
AWS CLI installed & configured
IAM permissions:
cloudtrail
cloudtrail
cloudtrail
s3

🚀 Step 1: Create S3 Bucket

~ aws s3api create-bucket \
  --bucket my-cloudtrail-logs-bucket \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1
  
🚀 Step 2: Create CloudTrail with Log Validation Enabled
~ aws cloudtrail create-trail \
  --name my-secure-trail \
  --s3-bucket-name my-cloudtrail-logs-bucket \
  --enable-log-file-validation
🚀 Step 3: Start Logging
aws cloudtrail start-logging --name my-secure-trail
🔍 Step 4: Verify Log File Integrity

Use the following command to validate logs:

~ aws cloudtrail validate-logs \
  --trail-arn <trail-arn> \
  --start-time 2024-01-01T00:00:00Z \
  --end-time 2024-01-02T00:00:00Z
  
📂 Processes:
CloudTrail delivers logs to S3
Generates digest files
Each digest file contains:
Hashes of log files
References to previous digest files
Uses SHA-256 hashing + digital signatures
✅ Expected Output
Validation successful → Logs are intact
Validation failed → Logs were tampered or missing

🔐 Security Best Practices:
Enable S3 versioning
Use SSE-KMS encryption
Restrict bucket access using IAM policies
Enable CloudTrail in all regions

📜 Bash Script to Enable CloudTrail

#!/bin/bash

TRAIL_NAME="my-secure-trail"
BUCKET_NAME="my-cloudtrail-logs-bucket"

aws cloudtrail create-trail \
  --name $TRAIL_NAME \
  --s3-bucket-name $BUCKET_NAME \
  --enable-log-file-validation

aws cloudtrail start-logging --name $TRAIL_NAME

📜 Bash Script to Validate Logs:
#!/bin/bash

TRAIL_ARN=$1

aws cloudtrail validate-logs \
  --trail-arn $TRAIL_ARN \
  --start-time $(date -u -d '1 day ago' +%Y-%m-%dT%H:%M:%SZ) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%SZ)

🧪 Testing Scenario
Enable CloudTrail:
Perform AWS actions (e.g., create EC2 instance)
Wait for logs to be delivered
Run validation command
Confirm integrity status
❌ Common Mistakes:
Forgetting --enable-log-file-validation
Incorrect trail ARN during validation
Not waiting for digest files to be generated
