data "aws_iam_policy_document" "trust_policy" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
        "ssm.amazonaws.com",
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_instance_role" {
  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = toset(["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"])
  role       = aws_iam_role.iam_instance_role.name
  policy_arn = each.key
}

data "aws_iam_policy_document" "kms_key_policy_iam_profile" {
  statement {
    effect = "Allow"

    actions = [
      "kms:Encrypt"

    ]
    resources = [aws_kms_key.this.arn]
  }

}

resource "aws_iam_role_policy" "kms" {
  role   = aws_iam_role.iam_instance_role.name
  name   = "inline-policy-kms-access"
  policy = data.aws_iam_policy_document.kms_key_policy_iam_profile.json
}

resource "aws_iam_instance_profile" "this" {
  name = local.name
  role = aws_iam_role.iam_instance_role.name
}

## S3 Bucket Acccess
data "template_file" "bucket_access_policy" {
  template = file("${path.module}/policies/bucket_access_policy_template.json")

  vars = {
    s3_mojo_file_transfer_arn = "arn:aws:s3:::mojo-file-transfer"
  }
}

resource "aws_iam_policy" "s3_bucket_access" {
  name   = "s3-bucket-access"
  policy = data.template_file.bucket_access_policy.rendered
}

resource "aws_iam_role_policy_attachment" "s3_bucket_access" {
  role       = aws_iam_role.iam_instance_role.name
  policy_arn = aws_iam_policy.s3_bucket_access.arn
}

