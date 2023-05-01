terraform {
  required_version = "~>1.4.6"

  required_providers {
    aws = {
      version = "~>4.65"
      source  = "hashicorp/aws"
    }
  }
}

variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

provider "aws" {
  region     = local.region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

locals {
  name   = "terraform-newrelic-sample"
  region = "us-east-1"
}
