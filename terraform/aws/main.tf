terraform {
  required_version = "~>1.4.6"

  required_providers {
    aws = {
      version = "~>4.65"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = local.region
}

locals {
  name   = "terraform-newrelic-sample"
  region = local.region
}
