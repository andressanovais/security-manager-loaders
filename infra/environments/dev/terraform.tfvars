lambda_name = "complete_vulnerabilities_loader"
lambda_timeout = 600

dynamo_table_name = "NistVulnerabilities"
dynamo_hash_key = "CveId"
dynamo_hash_key_type = "S"
dynamo_range_key = "Severity"
dynamo_range_key_type = "S"
dynamo_rcu = 500
dynamo_wcu = 500
dynamo_gsi_rcu = 100
dynamo_gsi_wcu = 100