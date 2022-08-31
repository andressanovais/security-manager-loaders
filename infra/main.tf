provider "aws" {
  access_key                  = "mock_access_key"
  region                      = "sa-east-1"
  secret_key                  = "mock_secret_key"
  s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    dynamodb    = "http://localhost:4566"
    lambda      = "http://localhost:4566"
    cloudwatch  = "http://localhost:4566"
    iam         = "http://localhost:4566"
    logs        = "http://localhost:4566"
    ssm         = "http://localhost:4566"
    eventbridge = "http://localhost:4566"
  }
}

module "complete_table_dynamodb" {
  source        = "./dynamodb"
  table_name    = "NistVulnerabilities"
  hash_key      = "CveId"
  hash_key_type = "S"
  rcu           = 500
  wcu           = 500
}

module "summarized_table_dynamodb" {
  source         = "./dynamodb"
  table_name     = "SummarizedNistVulnerabilities"
  hash_key       = "Severity"
  hash_key_type  = "S"
  range_key      = "Page"
  range_key_type = "N"
  rcu            = 500
  wcu            = 500
}

module "complete_loader_lambda" {
  source           = "./lambda"
  lambda_name      = "complete_vulnerabilities_loader"
  image_uri        = "uri:falsa:ecr"
  timeout          = 600
  policy_file_path = "./iam_documents/complete_loader_iam_policy.json"
}

# module "summarized_loader_lambda" {
#   source           = "./lambda"
#   lambda_name      = "summarized_vulnerabilities_loader"
#   image_uri        = "uri:falsa:ecr"
#   policy_file_path = "./iam_documents/summarized_loader_iam_policy.json"
# }

resource "aws_cloudwatch_event_rule" "every_six_hours" {
  name                = "every-six-hours"
  description         = "Fires every six hours"
  schedule_expression = "rate(6 hours)"
}

resource "aws_cloudwatch_event_target" "rule_lambda_trigger" {
  rule      = aws_cloudwatch_event_rule.every_six_hours.name
  target_id = "complete_vulnerabilities_loader"
  arn       = module.complete_loader_lambda.function_arn
}
