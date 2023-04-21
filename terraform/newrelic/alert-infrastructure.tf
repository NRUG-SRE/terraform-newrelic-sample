# ALB
resource "newrelic_infra_alert_condition" "unhealthy_host_count" {
  policy_id            = newrelic_alert_policy.this.id
  name                 = "Un healthy hosts exist"
  type                 = "infra_metric"
  select               = "provider.unhealthyHostCount.Average"
  integration_provider = "AlbTargetGroup"
  comparison           = "above"
  where                = "provider.targetGroupName = '${local.name}'"

  critical {
    duration      = 5
    value         = 0
    time_function = "all"
  }
}

resource "newrelic_infra_alert_condition" "increase_response_time" {
  policy_id            = newrelic_alert_policy.this.id
  name                 = "Increasing response time"
  type                 = "infra_metric"
  select               = "provider.targetResponseTime.Average"
  integration_provider = "AlbTargetGroup"
  comparison           = "above"
  where                = "provider.targetGroupName = '${local.name}'"

  critical {
    duration      = 5
    value         = 100
    time_function = "all"
  }

  warning {
    duration      = 5
    value         = 50
    time_function = "all"
  }
}

# EC2
resource "newrelic_infra_alert_condition" "host_not_reporting" {
  policy_id   = newrelic_alert_policy.this.id
  name        = "host not reporting"
  description = "Critical alert when the host is not reporting"
  type        = "infra_host_not_reporting"
  where       = "hostname = '${local.name}'"

  critical {
    duration = 5
  }
}

resource "newrelic_infra_alert_condition" "cpu" {
  policy_id  = newrelic_alert_policy.this.id
  name       = "High CPU Usage"
  type       = "infra_metric"
  event      = "SystemSample"
  select     = "cpuPercent"
  where      = "hostname = '${local.name}'"
  comparison = "above"

  critical {
    duration      = 5
    value         = 90
    time_function = "all"
  }

  warning {
    duration      = 5
    value         = 80
    time_function = "all"
  }
}

resource "newrelic_infra_alert_condition" "memory" {
  policy_id  = newrelic_alert_policy.this.id
  name       = "High Memory Usage"
  type       = "infra_metric"
  event      = "SystemSample"
  select     = "memoryUsedPercent"
  where      = "hostname = '${local.name}'"
  comparison = "above"

  critical {
    duration      = 5
    value         = 90
    time_function = "all"
  }

  warning {
    duration      = 5
    value         = 80
    time_function = "all"
  }
}

resource "newrelic_infra_alert_condition" "disk" {
  policy_id  = newrelic_alert_policy.this.id
  name       = "High Disk Usage"
  type       = "infra_metric"
  event      = "SystemSample"
  select     = "diskUsedPercent"
  where      = "hostname = '${local.name}'"
  comparison = "above"

  critical {
    duration      = 5
    value         = 90
    time_function = "all"
  }

  warning {
    duration      = 5
    value         = 80
    time_function = "all"
  }
}
