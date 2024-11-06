# Lambda function to stop EC2
data "archive_file" "lambda_stop_zip" {
  type        = "zip"
  source_file = "${path.module}/stop_ec2.py"
  output_path = "${path.module}/stop_ec2.zip"
}

resource "aws_lambda_function" "stop_ec2_lambda" {
  filename      = data.archive_file.lambda_stop_zip.output_path
  function_name = "stop_ec2_lambda"
  role          = aws_iam_role.lambda_exec.arn  
  handler       = "stop_ec2.lambda_handler"
  runtime       = "python3.12"
  environment {
    variables = {
      INSTANCE_ID = var.instance_id
    }
  }
}

# EventBridge Rule to Trigger Lambda on Schedule for shutdown
resource "aws_cloudwatch_event_rule" "lambda_stop_schedule" {
  name                = "lambda_stop_schedule_rule"
  schedule_expression = "cron(5 0 ? * 2-6 *)"  
}

resource "aws_cloudwatch_event_target" "lambda_stop_target" {
  rule      = aws_cloudwatch_event_rule.lambda_stop_schedule.name
  arn       = aws_lambda_function.stop_ec2_lambda.arn
}

resource "aws_lambda_permission" "allow_stop_cloudwatch" {
  statement_id  = "AllowStopExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_ec2_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_stop_schedule.arn
}
