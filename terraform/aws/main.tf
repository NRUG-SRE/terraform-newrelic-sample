terraform {
  required_version = "~>1.4.2"

  required_providers {
    aws = {
      version = "~>4.59"
      source  = "hashicorp/aws"
    }
  }
}

locals {
  name = "terraform-newrelic-sample"
}
