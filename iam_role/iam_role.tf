variable "name" {}
variable "policy" {}
variable "identifier" {}

resource "aws_iam_role" "walter" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.identifier]
    }
  }
}

resource "aws_iam_policy" "walter" {
  name   = var.name
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "walter" {
  role       = aws_iam_role.walter.name
  policy_arn = aws_iam_policy.walter.arn
}

output "iam_role_arn" {
  value = aws_iam_role.walter.arn
}

output "iam_role_name" {
  value = aws_iam_role.walter.name
}