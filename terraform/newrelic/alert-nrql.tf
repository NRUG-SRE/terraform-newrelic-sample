resource "newrelic_nrql_alert_condition" "latency" {
  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.this.id
  type                         = "static"
  name                         = "Latency (Fast-burn rate)"
  description                  = <<EOT
  Alerts you when 2% of your SLO error budget is spent in 1 hour.
  EOT
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Metric SELECT 100 - clamp_max(sum(newrelic.sli.good) / sum(newrelic.sli.valid) * 100, 100) as 'SLO compliance'  WHERE sli.guid = '${newrelic_service_level.latency.sli_guid}'"
  }

  critical {
    operator              = "above"
    threshold             = 3.3600000000000003
    threshold_duration    = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option        = "none"
  aggregation_window = 3600
  aggregation_method = "event_flow"
  aggregation_delay  = 120
  slide_by           = 60
}
