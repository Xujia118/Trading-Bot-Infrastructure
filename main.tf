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
  ami_id        = var.ami_id
  instance_type = var.instance_type
}

# Call S3 module
module "s3" {
  source = "./modules/s3"
}

resource "aws_s3_object" "ec2_instance_id_file" {
  bucket  = module.s3.bucket_name
  key     = "ec2-instance-id.txt"
  content = module.ec2.instance_id

  tags = {
    Name : "EC2 Instance ID"
  }
}

# Call Lambda
module "lambda" {
  source      = "./modules/lambda"
  instance_id = module.ec2.instance_id
}
