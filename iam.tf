#ポリシードキュメントの定義
data "aws_iam_policy_document" "allow_describe_regions" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeRegions"]
    resources = ["*"]
  }
}

#IAMポリシーの定義
resource "aws_iam_policy" "walter" {
  name   = "walter"
  policy = data.aws_iam_policy_document.allow_describe_regions.json
}

#信頼ポリシーの定義
#data "aws_iam_policy_document" "ec2_assume_role" {
#  statement {
#    actions = ["sts:AssumeRole"]
#    principals {
#      type        = "Service"
#      identifiers = ["ec2.amazonaws.com"]
#    }
#  }
#}

#IAMロールの定義
#resource "aws_iam_role" "walter" {
#  name               = "walter"
#  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
#}

#IAMポリシーのアタッチ
#resource "aws_iam_role_policy_attachment" "walter" {
#  role       = aws_iam_role.walter.name
#  policy_arn = aws_iam_policy.walter.arn
#}

#IAMモジュールの利用
module "describe_regions_for_ec2" {
  source     = "./iam_role"
  name       = "describe-regions-for-ec2"
  identifier = "ec2.amazonaws.com"
  policy     = data.aws_iam_policy_document.allow_describe_regions.json
}