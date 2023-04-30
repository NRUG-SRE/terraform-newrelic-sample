variable "base_url" {}
resource "newrelic_synthetics_monitor" "simple_browser" {
  status           = "ENABLED"
  name             = local.name
  period           = "EVERY_MINUTE"
  uri              = "http://${var.base_url}/bff/tracing-demo"
  type             = "SIMPLE"
  locations_public = ["AP_NORTHEAST_1"]

  custom_header {
    name  = "newrelic_simple_browser_header"
    value = "true"
  }

  treat_redirect_as_failure = true
  validation_string         = "{}"
  bypass_head_request       = true
  verify_ssl                = false
}

resource "newrelic_synthetics_alert_condition" "simple_browser" {
  policy_id = newrelic_alert_policy.this.id

  name       = "simple browser synthetics alert condition"
  monitor_id = newrelic_synthetics_monitor.simple_browser.id
}
