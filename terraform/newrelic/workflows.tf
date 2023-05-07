variable "slack_channel_name" {}
variable "slack_channel_id" {}

#resource "newrelic_notification_channel" "slack" {
#  account_id     = var.new_relic_account_id
#  name           = var.slack_channel_name
#  type           = "SLACK"
#  destination_id = var.slack_destination_id
#  product        = "IINT"
#
#  property {
#    key   = "channelId"
#    value = var.slack_channel_id
#  }
#
#  property {
#    key   = "customDetailsSlack"
#    value = "issue id - {{issueId}}"
#  }
#}
#
#resource "newrelic_workflow" "slack" {
#  name                  = "Slack Workflow"
#  muting_rules_handling = "NOTIFY_ALL_ISSUES"
#
#  issues_filter {
#    name = "Filter-name"
#    type = "FILTER"
#
#    predicate {
#      attribute = "labels.policyIds"
#      operator  = "EXACTLY_MATCHES"
#      values    = [newrelic_alert_policy.this.id]
#    }
#
#    predicate {
#      attribute = "priority"
#      operator  = "EQUAL"
#      values    = ["CRITICAL", "HIGH"]
#    }
#  }
#
#  destination {
#    channel_id = newrelic_notification_channel.slack.id
#  }
#}
