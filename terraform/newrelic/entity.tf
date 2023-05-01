data "newrelic_entity" "apm" {
  name   = "demo"
  type   = "APPLICATION"
  domain = "APM"
}
