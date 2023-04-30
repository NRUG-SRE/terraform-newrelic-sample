resource "newrelic_synthetics_alert_condition" "simple_browser" {
  policy_id = newrelic_alert_policy.this.id

  name       = "simple browser synthetics alert condition"
  monitor_id = newrelic_synthetics_monitor.simple_browser.id
}
