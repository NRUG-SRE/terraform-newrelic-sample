terraform {
  required_version = "~>1.4.2"

  required_providers {
    aws = {
      version = "~>4.59"
      source  = "hashicorp/aws"
    }
  }
}

variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

locals {
  name = "terraform-newrelic-sample"
}
