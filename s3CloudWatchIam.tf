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
