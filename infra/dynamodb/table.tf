resource "aws_dynamodb_table" "table" {
  name           = var.table_name
  billing_mode   = "PROVISIONED"
  hash_key       = var.hash_key
  range_key      = var.range_key
  read_capacity  = var.rcu
  write_capacity = var.wcu

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  dynamic "attribute" {
    for_each = var.range_key == null ? toset([]) : toset([1])
    content {
      name = var.range_key
      type = var.range_key_type
    }
  }

  server_side_encryption {
    enabled = true
  }

  lifecycle {
    ignore_changes = [read_capacity, write_capacity]
  }
}
