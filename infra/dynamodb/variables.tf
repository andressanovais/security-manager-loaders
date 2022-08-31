variable "table_name" {
  type = string
}

variable "hash_key" {
  type = string
}

variable "hash_key_type" {
  type = string
}

variable "range_key" {
  type    = string
  default = null
}

variable "range_key_type" {
  type    = string
  default = null
}

variable "rcu" {
  type    = number
  default = 5
}

variable "wcu" {
  type    = number
  default = 5
}
