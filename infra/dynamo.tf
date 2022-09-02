resource "aws_dynamodb_table" "table" {
  name           = var.dynamo_table_name
  billing_mode   = "PROVISIONED"
  hash_key       = var.dynamo_hash_key
  range_key      = var.dynamo_range_key
  read_capacity  = var.dynamo_rcu
  write_capacity = var.dynamo_wcu

  attribute {
    name = var.dynamo_hash_key
    type = var.dynamo_hash_key_type
  }

  attribute {
    name = var.dynamo_range_key
    type = var.dynamo_range_key_type
  }

  global_secondary_index {
    name               = "${var.dynamo_range_key}Index"
    hash_key           = var.dynamo_range_key
    read_capacity      = var.dynamo_gsi_rcu
    write_capacity     = var.dynamo_gsi_wcu
    projection_type    = "KEYS_ONLY"
  }

  server_side_encryption {
    enabled = true
  }

  lifecycle {
    ignore_changes = [read_capacity, write_capacity]
  }
}

