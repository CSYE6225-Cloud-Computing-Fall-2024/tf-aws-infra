resource "aws_lambda_function" "user_verification_lambda" {
  # Add the Lambda execution role permissions to access Secrets Manager and KMS
  depends_on    = [aws_secretsmanager_secret.email_credentials_secret]
  function_name = "UserVerificationLambda"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "com.swamyms.serverless.UserVerificationLambda::handleRequest"
  runtime       = "java17" # Or whichever runtime you're using

  # Set the timeout and memory size here
  timeout     = 30  # Increase to 10 seconds or more if necessary
  memory_size = 400 # Increase memory size to 256 MB or higher for better performance

  # Reference the Lambda code from the local file
  filename = "${path.module}/lambdaFunction/serverless-0.0.1-SNAPSHOT-plain.jar"

  #environment {
  #variables = {
  #MAILGUN_API_URL   = var.mailgun_api_url
  #MAILGUN_API_KEY   = var.mailgun_api_key
  #FROM_EMAIL        = var.from_email
  #VERIFICATION_LINK = var.verification_link
  #}
  #}
}

# Lambda Permission to allow SNS to invoke the Lambda function
resource "aws_lambda_permission" "allow_sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.user_verification_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.user_verification_topic.arn
}
