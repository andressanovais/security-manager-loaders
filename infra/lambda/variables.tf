variable "lambda_name" {
  type = string
}

variable "image_uri" {
  description = "ECR image URI containing the function's deployment package"
  type        = string
  default     = null
}

variable "runtime" {
  type    = string
  default = "python3.9"
}

variable "timeout" {
  type    = string
  default = 10
}

variable "policy_file_path" {
  type = string
}
