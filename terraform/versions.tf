terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "nett-terraform-states"
    encrypt = true
    key    = "prod/terraform.tfstate"
    region = "us-west-2"
//    dynamodb_table = "terraform-locks"
  }
}