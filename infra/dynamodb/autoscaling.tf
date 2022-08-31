# resource "aws_appautoscaling_target" "dynamodb_read_target" {
#   max_capacity       = 1000
#   min_capacity       = 100
#   resource_id        = var.table_name
#   scalable_dimension = "dynamodb:table:ReadCapacityUnits"
#   service_namespace  = "dynamodb"
# }

# resource "aws_appautoscaling_policy" "dynamodb_read_policy" {
#   name               = "DynamoDBReadCapacityUtilization-${aws_appautoscaling_target.dynamodb_read_target.resource_id}"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.dynamodb_read_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.dynamodb_read_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.dynamodb_read_target.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "DynamoDBReadCapacityUtilization"
#     }
#     target_value = 70
#   }
# }

# resource "aws_appautoscaling_target" "dynamodb_write_target" {
#   max_capacity       = 500
#   min_capacity       = 25
#   resource_id        = var.table_name
#   scalable_dimension = "dynamodb:table:WriteCapacityUnits"
#   service_namespace  = "dynamodb"
# }

# resource "aws_appautoscaling_policy" "dynamodb_write_policy" {
#   name               = "DynamoDBWriteCapacityUtilization-${aws_appautoscaling_target.dynamodb_read_target.resource_id}"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.dynamodb_read_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.dynamodb_read_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.dynamodb_read_target.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "DynamoDBWriteCapacityUtilization"
#     }
#     target_value = 70
#   }
# }