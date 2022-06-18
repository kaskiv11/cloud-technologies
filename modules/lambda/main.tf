locals {
  log_retention = 3
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = var.context
  name    = var.name
}

module "label_get_all_authors" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = var.context
  name    = "get-all-authors"
}

module "label_get_all_courses" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = var.context
  name    = "get-all-courses"
}

data "aws_region" "current" {}

module "lambda_function_get_all_authors" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "3.2.0"

  # function_name                     = "${module.label.id}-get-all-authors"
  function_name                     = module.label_get_all_authors.id
  description                       = "get all authors"
  handler                           = "index.handler"
  runtime                           = "nodejs12.x"
  create_role                       = false
  lambda_role                       = var.get_all_authors_role_arn
  use_existing_cloudwatch_log_group = true
  cloudwatch_logs_retention_in_days = 3

  source_path = "${path.module}/lambda_source/get_all_authors/index.js"

  environment_variables = {
    TABLE_NAME = var.dynamo_db_authors_name
  }

  tags = module.label.tags
  depends_on = [
    aws_cloudwatch_log_group.get_all_authors
  ]
}

module "lambda_function_get_all_courses" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "3.2.0"

  # function_name                     = "${module.label.id}-get-all-courses"
  function_name                     = module.label_get_all_courses.id
  description                       = "get all courses"
  handler                           = "index.handler"
  runtime                           = "nodejs12.x"
  create_role                       = false
  lambda_role                       = var.get_all_courses_role_arn
  use_existing_cloudwatch_log_group = true
  cloudwatch_logs_retention_in_days = 3


  source_path = "${path.module}/lambda_source/get_all_courses/index.js"

  environment_variables = {
    TABLE_NAME = var.dynamo_db_courses_name
  }

  tags = module.label.tags
  depends_on = [
    aws_cloudwatch_log_group.get_all_courses
  ]
}

# module "lambda_function_get_course" {
#   source  = "terraform-aws-modules/lambda/aws"
#   version = "3.2.0"

#   # function_name                     = "${module.label.id}-get-course"
#   function_name                     = module.label_get_course.id
#   description                       = "get  course"
#   handler                           = "index.handler"
#   runtime                           = "nodejs12.x"
#   create_role                       = false
#   lambda_role                       = var.get_course_role_arn
#   use_existing_cloudwatch_log_group = true
#   cloudwatch_logs_retention_in_days = 3


#   source_path = "${path.module}/lambda_source/get_course/get-course.js"

#   environment_variables = {
#     TABLE_NAME = var.dynamo_db_courses_name
#   }

#   tags = module.label.tags
#   depends_on = [
#     aws_cloudwatch_log_group.get_course
#   ]
# }


# module "lambda_function_save_course" {
#   source  = "terraform-aws-modules/lambda/aws"
#   version = "3.2.0"

#   # function_name                     = "${module.label.id}-save-course"
#   function_name                     = module.label_save_course.id
#   description                       = "save course"
#   handler                           = "index.handler"
#   runtime                           = "nodejs12.x"
#   create_role                       = false
#   lambda_role                       = var.save_course_role_arn
#   use_existing_cloudwatch_log_group = true
#   cloudwatch_logs_retention_in_days = 3


#   source_path = "${path.module}/lambda_source/save_course/save-course.js"

#   environment_variables = {
#     TABLE_NAME = var.dynamo_db_courses_name
#   }

#   tags = module.label.tags
#   depends_on = [
#     aws_cloudwatch_log_group.save_course
#   ]
# }

# module "lambda_function_delete_course" {
#   source  = "terraform-aws-modules/lambda/aws"
#   version = "3.2.0"

#   # function_name                     = "${module.label.id}-delete-course"
#   function_name                     = module.label_delete_course.id
#   description                       = "delete course"
#   handler                           = "index.handler"
#   runtime                           = "nodejs12.x"
#   create_role                       = false
#   lambda_role                       = var.delete_course_role_arn
#   use_existing_cloudwatch_log_group = true
#   cloudwatch_logs_retention_in_days = 3


#   source_path = "${path.module}/lambda_source/save_course/delete-course.js"

#   environment_variables = {
#     TABLE_NAME = var.dynamo_db_courses_name
#   }

#   tags = module.label.tags
#   depends_on = [
#     aws_cloudwatch_log_group.delete_course
#   ]
# }

# module "lambda_function_update_course" {
#   source  = "terraform-aws-modules/lambda/aws"
#   version = "3.2.0"

#   # function_name                     = "${module.label.id}-update-course"
#   function_name                     = module.label_update_course.id
#   description                       = "update course"
#   handler                           = "index.handler"
#   runtime                           = "nodejs12.x"
#   create_role                       = false
#   lambda_role                       = var.update_course_role_arn
#   use_existing_cloudwatch_log_group = true
#   cloudwatch_logs_retention_in_days = 3


#   source_path = "${path.module}/lambda_source/save_course/update-course.js"

#   environment_variables = {
#     TABLE_NAME = var.dynamo_db_courses_name
#   }

#   tags = module.label.tags
#   depends_on = [
#     aws_cloudwatch_log_group.update_course
#   ]
# }

resource "aws_cloudwatch_log_group" "get_all_authors" {
  name              = format("/aws/lambda/%s", module.label_get_all_authors.id)
  retention_in_days = local.log_retention

  # tags = merge(var.tags,
  #   { Function = format("%s", module.label_get_all_authors.id) }
  # )
}

resource "aws_cloudwatch_log_group" "get_all_courses" {
  name              = format("/aws/lambda/%s", module.label_get_all_courses.id)
  retention_in_days = local.log_retention

  # tags = merge(var.tags,
  #   { Function = format("%s", module.label_get_all_courses.id) }
  # )
}

# resource "aws_cloudwatch_log_group" "get_course" {
#   name              = format("/aws/lambda/%s", module.label_get_course.id)
#   retention_in_days = local.log_retention

#   # tags = merge(var.tags,
#   #   { Function = format("%s", module.label_get_all_authors.id) }
#   # )
# }

# resource "aws_cloudwatch_log_group" "delete_course" {
#   name              = format("/aws/lambda/%s", module.label_delete_course.id)
#   retention_in_days = local.log_retention

#   # tags = merge(var.tags,
#   #   { Function = format("%s", module.label_get_all_authors.id) }
#   # )
# }

# resource "aws_cloudwatch_log_group" "save_course" {
#   name              = format("/aws/lambda/%s", module.label_save_course.id)
#   retention_in_days = local.log_retention

#   # tags = merge(var.tags,
#   #   { Function = format("%s", module.label_get_all_authors.id) }
#   # )
# }

# resource "aws_cloudwatch_log_group" "update_course" {
#   name              = format("/aws/lambda/%s", module.label_update_course.id)
#   retention_in_days = local.log_retention

#   # tags = merge(var.tags,
#   #   { Function = format("%s", module.label_get_all_authors.id) }
#   # )
# }

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function_get_all_authors.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.aws_lambda_permission_api_gateway_source_arn}/*${var.aws_api_gateway_resource_authors_path}"
}