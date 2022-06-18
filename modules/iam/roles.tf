data "aws_iam_policy_document" "get_all_authors" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "get_all_authors" {
  name               = "${module.label.id}-get-all-authors"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.get_all_authors.json
}

resource "aws_iam_role_policy_attachment" "get_all_authors" {
  role       = aws_iam_role.get_all_authors.name
  policy_arn = aws_iam_policy.get_all_authors.arn
}

resource "aws_iam_role_policy_attachment" "get_all_authors_cloudwatch" {
  role       = aws_iam_role.get_all_authors.name
  policy_arn = aws_iam_policy.get_all_authors_cloudwatch.arn
}
