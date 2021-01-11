locals {
  datadog_enable = length(var.external_id) > 0 ? 1 : 0
  role_name      = "DatadogAWSIntegrationRole"
}

data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::464622532012:root",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [
        var.external_id,
      ]
    }
  }
}

data "aws_iam_policy_document" "policy_document" {
  statement {
    actions = [
      "autoscaling:Describe*",
      "budgets:ViewBudget",
      "cloudfront:GetDistributionConfig",
      "cloudfront:ListDistributions",
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrailStatus",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "codedeploy:List*",
      "codedeploy:BatchGet*",
      "directconnect:Describe*",
      "dynamodb:List*",
      "dynamodb:Describe*",
      "ec2:Describe*",
      "ecs:Describe*",
      "ecs:List*",
      "elasticache:Describe*",
      "elasticache:List*",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeTags",
      "elasticloadbalancing:Describe*",
      "elasticmapreduce:List*",
      "elasticmapreduce:Describe*",
      "es:ListTags",
      "es:ListDomainNames",
      "es:DescribeElasticsearchDomains",
      "health:DescribeEvents",
      "health:DescribeEventDetails",
      "health:DescribeAffectedEntities",
      "kinesis:List*",
      "kinesis:Describe*",
      "lambda:AddPermission",
      "lambda:GetPolicy",
      "lambda:List*",
      "lambda:RemovePermission",
      "logs:Get*",
      "logs:Describe*",
      "logs:FilterLogEvents",
      "logs:TestMetricFilter",
      "rds:Describe*",
      "rds:List*",
      "redshift:DescribeClusters",
      "redshift:DescribeLoggingStatus",
      "route53:List*",
      "s3:GetBucketLogging",
      "s3:GetBucketLocation",
      "s3:GetBucketNotification",
      "s3:GetBucketTagging",
      "s3:ListAllMyBuckets",
      "s3:PutBucketNotification",
      "ses:Get*",
      "sns:List*",
      "sns:Publish",
      "sqs:ListQueues",
      "support:*",
      "tag:getResources",
      "tag:getTagKeys",
      "tag:getTagValues",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy" {
  count  = local.datadog_enable
  name   = local.role_name
  policy = length(var.custom_policy) > 0 ? var.custom_policy : data.aws_iam_policy_document.policy_document.json
}

resource "aws_iam_role" "role" {
  count              = local.datadog_enable
  name               = local.role_name
  tags               = var.tags
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
}

resource "aws_iam_role_policy_attachment" "attachment" {
  count      = local.datadog_enable
  policy_arn = aws_iam_policy.policy[0].arn
  role       = aws_iam_role.role[0].name
}
