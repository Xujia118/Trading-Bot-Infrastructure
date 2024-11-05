# Lambda role and policy
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_start_ec2_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [{
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_start_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Create zip file
data "archive_file" "lambda_zip" {
    type = "zip"
    source_file = "${path.module}/start_ec2.py"
    output_path = "${path.module}/start_ec2.zip"
}

# Lambda function to start EC2
resource "aws_lambda_function" "start_ec2_lambda" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "start_ec2_lambda"
  role          = aws_iam_role.lambda_exec.arn  
  handler       = "start_ec2.lambda_handler"
  runtime       = "python3.12"
  environment {
    variables = {
      INSTANCE_ID = var.instance_id
    }
  }
}

# EventBridge Rule to Trigger Lambda on Schedule
resource "aws_cloudwatch_event_rule" "lambda_schedule" {
  name                = "lambda_start_schedule_rule"
  schedule_expression = "cron(0 0 ? * 2-6 *)"  # UTC time
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lambda_schedule.name
  arn       = aws_lambda_function.start_ec2_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_ec2_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_schedule.arn
}
