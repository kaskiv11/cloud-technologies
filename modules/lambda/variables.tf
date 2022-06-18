variable "dynamo_db_authors_name" {
  type = string
}

variable "dynamo_db_courses_name" {
  type = string
}

variable "get_all_authors_role_arn" {
  type = string
}

variable "get_all_courses_role_arn" {
  type = string
}

# variable "get_course_role_arn" {
#   type = string
# }

# variable "save_course_role_arn" {
#   type = string
# }

# variable "update_course_role_arn" {
#   type = string
# }

# variable "delete_course_role_arn" {
#   type = string
# }

variable "aws_lambda_permission_api_gateway_source_arn" {
  type = string
  default = ""
}

variable "aws_api_gateway_resource_authors_id" {
  type = string
  default = ""
}

variable "aws_api_gateway_resource_authors_path" {
  type = string
  default = ""
}