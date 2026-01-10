variable "arn_role_policy" {
  type = string

  default = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

variable "s3_bucket_name" {
  type = string

  default = "s3-config-delivery_Channel-051399"
}