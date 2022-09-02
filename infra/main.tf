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
