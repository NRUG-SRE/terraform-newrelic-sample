variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "new_relic_api_key" {}
variable "new_relic_account_id" {}

locals {
  name = "terraform-newrelic-sample"
}
