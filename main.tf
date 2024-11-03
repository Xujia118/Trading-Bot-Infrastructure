terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

# Call EC2 module
module "ec2" {
  source        = "./modules/ec2"
  ami_id       = var.ami_id
  instance_type = var.instance_type
}
