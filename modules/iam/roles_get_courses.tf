data "aws_iam_policy_document" "get_all_courses" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "get_all_courses" {
  name               = "${module.label.id}-get-all-courses"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.get_all_courses.json
}

resource "aws_iam_role_policy_attachment" "get_all_courses" {
  role       = aws_iam_role.get_all_courses.name
  policy_arn = aws_iam_policy.get_all_courses.arn
}

resource "aws_iam_role_policy_attachment" "get_all_courses_cloudwatch" {
  role       = aws_iam_role.get_all_courses.name
  policy_arn = aws_iam_policy.get_all_courses_cloudwatch.arn
}
