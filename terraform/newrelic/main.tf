terraform {
  required_version = "~>1.4.2"

  required_providers {
    aws = {
      version = "~>4.59"
      source  = "hashicorp/aws"
    }

    newrelic = {
      source  = "newrelic/newrelic"
      version = "~>3.20"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

provider "newrelic" {
  account_id = var.new_relic_account_id
  region     = "US"
  api_key    = var.new_relic_api_key
}
