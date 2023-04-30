data "newrelic_account" "this" {
  name = var.new_relic_account_name
}

data "newrelic_entity" "apm" {
  name   = "demo"
  type   = "APPLICATION"
  domain = "APM"
}

resource "newrelic_workload" "this" {
  name       = local.name
  account_id = data.newrelic_account.this.id

  entity_guids = [
    data.newrelic_entity.apm.guid,
  ]

  # apm entities
  entity_search_query {
    query = "name LIKE 'demo-%'"
  }

  # synthetics entities
  entity_search_query {
    query = "(domain = 'SYNTH' AND type = 'MONITOR' AND name = '${local.name}')"
  }

  # sli entities
  entity_search_query {
    query = "(domain = 'EXT' AND type = 'SERVICE_LEVEL' AND name = 'Latency')"
  }

  # other entities
  entity_search_query {
    query = "name LIKE '%${local.name}%'"
  }

  scope_account_ids = [data.newrelic_account.this.id]
}
