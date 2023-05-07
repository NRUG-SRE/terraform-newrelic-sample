variable "slack_workspace_name" {}
variable "slack_destination_id" {}

#resource "newrelic_notification_destination" "slack" {
#  name = var.slack_workspace_name
#  type = "SLACK"
#
#  lifecycle {
#    ignore_changes = [auth_token]
#  }
#
#  property {
#    key   = "scope"
#    label = "Permissions"
#    value = "app_mentions:read,channels:join,channels:read,chat:write,chat:write.public,commands,groups:read,links:read,links:write,team:read,users:read"
#  }
#
#  property {
#    key   = "teamName"
#    label = "Team Name"
#    value = var.slack_workspace_name
#  }
#}
