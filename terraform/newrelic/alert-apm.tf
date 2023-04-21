resource "newrelic_alert_condition" "apdex" {
  policy_id       = newrelic_alert_policy.this.id
  name            = "Apdex Score is Low"
  type            = "apm_app_metric"
  entities        = [data.newrelic_entity.apm.application_id]
  metric          = "apdex"
  condition_scope = "application"

  term {
    duration      = 5
    operator      = "below"
    priority      = "critical"
    threshold     = 0.75
    time_function = "all"
  }

  term {
    duration      = 5
    operator      = "below"
    priority      = "warning"
    threshold     = 0.90
    time_function = "all"
  }
}

resource "newrelic_alert_condition" "error_rate" {
  policy_id       = newrelic_alert_policy.this.id
  name            = "Error Rate is High"
  type            = "apm_app_metric"
  entities        = [data.newrelic_entity.apm.application_id]
  metric          = "error_percentage"
  condition_scope = "application"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = 50
    time_function = "all"
  }

  term {
    duration      = 5
    operator      = "above"
    priority      = "warning"
    threshold     = 30
    time_function = "all"
  }
}

resource "newrelic_alert_condition" "response_time" {
  policy_id       = newrelic_alert_policy.this.id
  name            = "Response Time is High"
  type            = "apm_app_metric"
  entities        = [data.newrelic_entity.apm.application_id]
  metric          = "response_time_web"
  condition_scope = "application"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = 1000
    time_function = "all"
  }

  term {
    duration      = 5
    operator      = "above"
    priority      = "warning"
    threshold     = 500
    time_function = "all"
  }
}
