module "notification_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = module.base_labels.context
  name    = "notification"
}

module "notify_slack" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "5.1.0"

  sns_topic_name = module.notification_label.id

  slack_webhook_url = var.slack_webhook_url
  slack_channel     = "aws-notification"
  slack_username    = "terraform-reporter"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = module.notify_slack.slack_topic_arn
  protocol  = "email"
  # endpoint  = "yrameda0404@gmail.com"
  endpoint  = var.sns_topic_subscription_email
  
}

resource "aws_cloudwatch_log_metric_filter" "this" {
  name           = module.notification_label.id
  pattern        = "?ERROR ?WARN ?5xx"
  log_group_name = "/aws/lambda/${module.lambda.get_all_authors_lambda_function_name}"
  # log_group_name = module.lambda.get_all_authors_lambda_cloudwatch_log_group_name

  metric_transformation {
    name      = module.notification_label.id
    namespace = module.notification_label.id
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = module.notification_label.id
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = module.notification_label.id
  namespace           = module.notification_label.id
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "This metric monitors ${module.lambda.get_all_authors_lambda_function_name}"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [module.notify_slack.slack_topic_arn]
}
