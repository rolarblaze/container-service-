terraform {
  #required_version = "1.14.3."
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# by default it would use a local statefile but we can also use a remote state backend like s3 or terraform cloud

# terraform {
#     backend "s3" {
#         bucket = "my-terraform-devroland-bucket"
#         key = "bootcamp/terraform/terraform.tfstate"
#         region = "us-east-1"
#         encrypt = true
#     }
# }