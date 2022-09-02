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
  table_name    = var.dynamo_table_name
  hash_key      = var.dynamo_hash_key
  hash_key_type = var.dynamo_hash_key_type
  rcu           = var.dynamo_rcu
  wcu           = var.dynamo_wcu
}

# module "summarized_loader_lambda" {
#   source           = "./lambda"
#   lambda_name      = "summarized_vulnerabilities_loader"
#   image_uri        = "uri:falsa:ecr"
#   policy_file_path = "./iam_documents/summarized_loader_iam_policy.json"
# }

resource "aws_cloudwatch_event_rule" "one_time_trigger" {
  name                = "one-time"
  description         = "Fires one time at specific hour"
  schedule_expression = "cron(16 01 31 08 ? 2022)" # cron(Minutes Hours Day-of-month Month Day-of-week Year)
}

resource "aws_cloudwatch_event_target" "rule_lambda_trigger" {
  rule      = aws_cloudwatch_event_rule.one_time_trigger.name
  target_id = "complete_vulnerabilities_loader"
  arn       = module.complete_loader_lambda.function_arn
}
