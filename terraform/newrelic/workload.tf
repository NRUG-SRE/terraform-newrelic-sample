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

  entity_search_query {
    query = "tags.displayName like '%${local.name}%'"
  }

  entity_search_query {
    query = "name LIKE 'demo-%'"
  }

  scope_account_ids = [data.newrelic_account.this.id]
}
