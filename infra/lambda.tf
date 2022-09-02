resource "aws_lambda_function" "function" {
  function_name = var.lambda_name
  # image_uri     = var.image_uri
  handler  = "lambda_handler.handler"
  role     = aws_iam_role.lambda_role.arn
  runtime  = var.lambda_runtime
  timeout  = var.lambda_timeout

  depends_on = [
    aws_cloudwatch_log_group.log_group,
    aws_iam_role_policy_attachment.lambda_role_policy
  ]

  # vpc_config {
  # TODO
  #   subnet_ids         = [aws_subnet.subnet.id]
  #   security_group_ids = [aws_security_group.sg_for_lambda.id]
  # }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 14
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.lambda_name}_policy"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "${var.lambda_name}_policy"
  policy = file("iam_policies/complete_loader_iam_policy.json")
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_cloudwatch_event_rule" "every_six_hours" {
  name                = "every-six-hours"
  description         = "Fires every six hours"
  schedule_expression = "rate(6 hours)"
}

resource "aws_cloudwatch_event_target" "rule_lambda_trigger" {
  rule      = aws_cloudwatch_event_rule.every_six_hours.name
  target_id = var.lambda_name
  arn       = aws_lambda_function.function.arn
}

# resource security_group sg_for_lambda {
# TODO
# }
