resource "newrelic_alert_policy" "this" {
  name                = local.name
  incident_preference = "PER_CONDITION"
}
