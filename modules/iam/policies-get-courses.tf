data "aws_iam_policy_document" "get_all_courses_dynamo" {
  statement {
    sid = "dynamodb"

    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:ListBackups",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]

    resources = [
      "${var.dynamo_db_courses_arn}",
    ]
  }
}

resource "aws_iam_policy" "get_all_courses" {
  name   = "${module.label.id}-get-all-courses"
  path   = "/"
  policy = data.aws_iam_policy_document.get_all_courses_dynamo.json
}

data "aws_iam_policy_document" "get_all_courses_cloudwatch" {
  statement {
    sid = "cloudwatch"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      var.cw_log_group_get_all_courses_arn,
      "${var.cw_log_group_get_all_courses_arn}:*"
    ]
  }
}

resource "aws_iam_policy" "get_all_courses_cloudwatch" {
  name   = "${module.label.id}-get-all-courses-cw"
  path   = "/"
  policy = data.aws_iam_policy_document.get_all_courses_cloudwatch.json
}
