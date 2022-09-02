variable "lambda_name" {
  type = string
}

variable "lambda_runtime" {
  type    = string
  default = "python3.9"
}

variable "lambda_timeout" {
  type    = number
}

variable "dynamo_table_name" {
  type = string
}

variable "dynamo_hash_key" {
  type = string
}

variable "dynamo_hash_key_type" {
  type = string
}

variable "dynamo_rcu" {
  type = number
}

variable "dynamo_wcu" {
  type = number
}

