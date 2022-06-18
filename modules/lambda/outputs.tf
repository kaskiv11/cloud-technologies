output "cw_log_group_get_all_authors_arn" {
  value = aws_cloudwatch_log_group.get_all_authors.arn
}

output "cw_log_group_get_all_courses_arn" {
  value = aws_cloudwatch_log_group.get_all_courses.arn
}

output "get_all_courses_lambda_function_name" {
  value = module.lambda_function_get_all_courses.lambda_function_name
}

output "get_all_authors_lambda_function_name" {
  value = module.lambda_function_get_all_authors.lambda_function_name
}

output "get_all_authors_lambda_cloudwatch_log_group_name" {
  value = module.lambda_function_get_all_authors.lambda_cloudwatch_log_group_name
}

output "get_all_authors_invoke_arn" {
  value = module.lambda_function_get_all_authors.lambda_function_invoke_arn
}