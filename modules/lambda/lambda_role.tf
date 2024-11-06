# Lambda role and policy
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_ec2_control_role"
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

# Policy with permissions to start and stop instances
resource "aws_iam_policy" "ec2_control_policy" {
  name = "ec2_control_policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:StartInstances",
          "ec2:StopInstances"
        ],
        "Resource": "*"
      }
    ]
  })
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "ec2_control_policy_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.ec2_control_policy.arn
}