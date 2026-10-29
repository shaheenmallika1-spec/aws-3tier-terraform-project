terraform {
  backend "s3" {
    bucket       = "aws-3tier-app-files-059865587314-sydney-20261029"
    key          = "terraform/state/terraform.tfstate"
    region       = "ap-southeast-2"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}