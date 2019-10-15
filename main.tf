# This is required to get the AWS region via ${data.aws_region.current}.
#data "aws_region" "current" {
#}
provider "aws" {
  region = "us-east-1"
}

# Define a Lambda function.
#
# The handler is the name of the executable for go1.x runtime.
resource "aws_lambda_function" "hello" {
  function_name    = "hello"
  filename         = "hello.zip"
  handler          = "hello"
  source_code_hash = "${base64sha256(filebase64("hello.zip"))}"
  role             = "${aws_iam_role.hello.arn}"
  runtime          = "go1.x"
  memory_size      = 128
  timeout          = 1
}

# A Lambda function may access to other AWS resources such as S3 bucket. So an
# IAM role needs to be defined. This hello world example does not access to
# any resource, so the role is empty.
#
# The date 2012-10-17 is just the version of the policy language used here [1].
#
# [1]: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_version.html
resource "aws_iam_role" "hello" {
  name               = "hello"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Attach the AWS managed AWSLambdaBasicExecutionRole policy
resource "aws_iam_policy_attachment" "AWSLambdaBasicExecutionRole" {
  name = "AWSLambdaBasicExecutionRole"
  roles = ["${aws_iam_role.hello.id}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create a CloudWatch event firing every minute
resource "aws_cloudwatch_event_rule" "hello_cron" {
  name                = "hello_cron"
  description         = "Cron-based event trigger every minute"
  schedule_expression = "cron(0/1 * * * ? *)"
}

# Map the lambda function as a target of the cloudwatch event
resource "aws_cloudwatch_event_target" "hello_cron_target" {
  target_id = "hello_cron"
  arn       = "${aws_lambda_function.hello.arn}"
  rule      = "${aws_cloudwatch_event_rule.hello_cron.name}"
}

# Add cloudwatch cron event as a trigger for the lambda
resource "aws_lambda_permission" "hello_cron_invoke_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.hello.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.hello_cron.arn}"
}
