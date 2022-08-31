resource "aws_ssm_parameter" "last_run_time" {
  name  = "/securityManager/vulnerabilities/loader/lastRunTime"
  type  = "String"
  value = "empty"
}
