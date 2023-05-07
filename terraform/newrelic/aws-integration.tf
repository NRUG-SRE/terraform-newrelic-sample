data "aws_iam_policy" "read_only_access" {
  name = "ReadOnlyAccess"
}

data "aws_iam_policy_document" "newrelic_integrations" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      values   = [var.new_relic_account_id]
      variable = "sts:ExternalID"
    }

    principals {
      # https://docs.newrelic.com/jp/docs/infrastructure/amazon-integrations/connect/connect-aws-new-relic-infrastructure-monitoring/#connect
      identifiers = ["754728514883"]
      type        = "AWS"
    }
  }
}

resource "aws_iam_role" "newrelic_integrations" {
  name                = "NewRelicInfrastructure-Integrations"
  assume_role_policy  = data.aws_iam_policy_document.newrelic_integrations.json
  managed_policy_arns = [data.aws_iam_policy.read_only_access.arn]
}

data "aws_iam_policy_document" "budget_access" {
  statement {
    actions   = ["budgets:ViewBudget"]
    effect    = "Allow"
    resources = ["*"]
  }
  version = "2012-10-17"
}

resource "aws_iam_role_policy" "view_budget_access" {
  name   = "view-budget-access"
  policy = data.aws_iam_policy_document.budget_access.json
  role   = aws_iam_role.newrelic_integrations.id
}

resource "newrelic_cloud_aws_link_account" "aws_integration" {
  account_id             = var.new_relic_account_id
  arn                    = aws_iam_role.newrelic_integrations.arn
  metric_collection_mode = "PULL"
  name                   = local.name

  depends_on = [
    aws_iam_role.newrelic_integrations,
    data.aws_iam_policy_document.newrelic_integrations,
    data.aws_iam_policy_document.budget_access,
  ]
}

resource "newrelic_cloud_aws_integrations" "aws_integration" {
  linked_account_id = newrelic_cloud_aws_link_account.aws_integration.id

  health {
    metrics_polling_interval = 6000
  }

  vpc {
    metrics_polling_interval = 6000
    aws_regions              = [local.region]
  }

  billing {
    metrics_polling_interval = 6000
  }
}
