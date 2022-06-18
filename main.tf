module "iam" {
  source                           = "./modules/iam"
  context                          = module.base_labels.context
  name                             = "iam"
  dynamo_db_authors_arn            = module.authors.arn
  dynamo_db_courses_arn            = module.course.arn
  cw_log_group_get_all_authors_arn = module.lambda.cw_log_group_get_all_authors_arn
  cw_log_group_get_all_courses_arn = module.lambda.cw_log_group_get_all_courses_arn
}

module "lambda" {
  source                   = "./modules/lambda"
  context                  = module.base_labels.context
  name                     = "lambda"
  dynamo_db_authors_name   = module.authors.id
  dynamo_db_courses_name   = module.course.id
  get_all_authors_role_arn = module.iam.get_all_authors_role_arn
  get_all_courses_role_arn = module.iam.get_all_courses_role_arn
  # get_course_role_arn = module.iam.get_course_role_arn
  # save_course_role_arn = module.iam.save_course_role_arn
  # delete_course_role_arn = module.iam.delete_course_role_arn
  # update_course_role_arn = module.iam.update_course_role_arn
  aws_lambda_permission_api_gateway_source_arn = aws_api_gateway_rest_api.this.execution_arn
  aws_api_gateway_resource_authors_id          = aws_api_gateway_resource.authors.id
  aws_api_gateway_resource_authors_path        = aws_api_gateway_resource.authors.path
}

module "frontend" {
  source                         = "./modules/s3-cloudfront-website"
  context                        = module.base_labels.context
  name                           = "frontend"
  domain_name                    = "dev.garber1329.lpnu.ua"
  website_cloudfront_min_ttl     = "300"
  website_cloudfront_default_ttl = "300"
  website_cloudfront_max_ttl     = "300"
}



###
# resource "aws_lambda_function" "this" {
#   function_name = var.function_name
#   filename      = module.lambda_file.payload_file
#   role          = var.role
#   handler       = var.handler
#   description   = var.description
#   dynamic "environment" {
#     for_each = var.environment == null ? [] : [var.environment]
#     content {
#       variables = var.environment
#     }
#   }
#   vpc_config  {
#     subnet_ids         = var.subnet_ids
#     security_group_ids = var.security_group_ids
#   }

#   layers                         = var.layers
#   runtime                        = var.runtime
#   publish                        = var.publish
#   timeout                        = var.timeout
#   memory_size                    = var.memory_size
#   tags                           = var.tags
#   reserved_concurrent_executions = var.reserved_concurrent_executions
#   depends_on                     = [aws_cloudwatch_log_group.this]
# }


# resource "aws_cloudwatch_log_group" "this" {
#   name              = format("/aws/lambda/%s", var.function_name)
#   retention_in_days = var.log_retention

#   tags = merge(var.tags,
#     { Function = format("%s", var.function_name) }
#   )
# }


