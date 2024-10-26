# IAM Role for EC2 to access S3
resource "aws_iam_role" "example_s3_role" {
  name = "ec2-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the managed AmazonS3FullAccess policy initially
resource "aws_iam_role_policy_attachment" "attach_full_s3_policy" {
  role       = aws_iam_role.example_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" # Initial development
}

# Instance profile for EC2
resource "aws_iam_instance_profile" "example_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.example_s3_role.name
}