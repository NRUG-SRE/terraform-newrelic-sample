data "newrelic_entity" "apm" {
  name   = "demo"
  type   = "APPLICATION"
  domain = "APM"
}

resource "newrelic_workload" "this" {
  name       = local.name
  account_id = var.new_relic_account_id

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

  scope_account_ids = [var.new_relic_account_id]
}
