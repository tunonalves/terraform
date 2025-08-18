terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.83.1"
    }
  }
  required_version = "~>1.10.5"
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "us-east-2"
  alias  = "ohio"
}
