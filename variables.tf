variable "arn_role_policy" {
  type = string

  default = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

variable "config_status" {
  type = bool

  default = true
}