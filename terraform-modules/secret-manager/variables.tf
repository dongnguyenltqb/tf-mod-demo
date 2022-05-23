variable "secret_name" {
  type = string
  nullable = false
}

variable "secret_value" {
  type = map(string)
  nullable = false
}
