# Define the IAM Role
resource "aws_iam_role" "app_instance_role" {
  name = "app-instance-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# S3 Policy for Accessing S3 Resources
resource "aws_iam_policy" "s3_access_policy" {
  name = "s3-access-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# CloudWatch Policy for Logging and Metrics
resource "aws_iam_policy" "cloudwatch_agent_policy" {
  name = "cloudwatch-agent-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Define the IAM Role for Lambda execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# SNS Policy to allow EC2 role to publish to the SNS topic
resource "aws_iam_policy" "sns_publish_policy" {
  name        = "sns-publish-policy"
  description = "Policy to allow EC2 instance to publish to SNS topic"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sns:Publish",
        "Resource" : aws_sns_topic.user_verification_topic.arn
      }
    ]
  })
}

# Attach both policies to the IAM Role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.app_instance_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy" {
  role       = aws_iam_role.app_instance_role.name
  policy_arn = aws_iam_policy.cloudwatch_agent_policy.arn
}

# Create an IAM Instance Profile for the Role
resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "app-instance-profile"
  role = aws_iam_role.app_instance_role.name
}

# Attach SNS publish policy to the EC2 role
resource "aws_iam_role_policy_attachment" "attach_sns_publish_policy" {
  role       = aws_iam_role.app_instance_role.name
  policy_arn = aws_iam_policy.sns_publish_policy.arn
}


# Create an IAM Instance Profile for the Lambda function (if needed)
resource "aws_iam_instance_profile" "lambda_instance_profile" {
  name = "lambda-instance-profile"
  role = aws_iam_role.lambda_execution_role.name
}
