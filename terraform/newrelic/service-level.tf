resource "newrelic_service_level" "latency" {
  guid        = data.newrelic_entity.apm.id
  name        = "Latency"
  description = "Proportion of requests that are served faster than a threshold."

  events {
    account_id = var.new_relic_account_id

    valid_events {
      from  = "Transaction"
      where = "appName = '${data.newrelic_entity.apm.name}' AND (transactionType='Web')"
    }

    good_events {
      from  = "Transaction"
      where = "appName = '${data.newrelic_entity.apm.name}' AND (transactionType= 'Web') AND duration < 0.1"
    }
  }

  objective {
    target = 99.00

    time_window {
      rolling {
        count = 7
        unit  = "DAY"
      }
    }
  }
}
