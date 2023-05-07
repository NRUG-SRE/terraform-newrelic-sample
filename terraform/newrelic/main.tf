terraform {
  required_version = "~>1.4.6"

  required_providers {
    aws = {
      version = "~>4.65"
      source  = "hashicorp/aws"
    }

    newrelic = {
      source  = "newrelic/newrelic"
      version = "~>3.21"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
}

provider "newrelic" {
  account_id = var.new_relic_account_id
  region     = "US"
  api_key    = var.new_relic_api_key
}
