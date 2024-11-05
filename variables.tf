variable "aws_access_key_id" {
    description = "AWS Access Key ID"
    type        = string
    sensitive   = true
}

variable "aws_secret_access_key" {
    description = "AWS Secret Access Key"
    type        = string
    sensitive   = true
}

variable "aws_region" {
    description = "The AWS region for resources"
    type        = string
    default     = "us-west-2"  
}

variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t2.micro"    
}

variable "ami_id" {
    description = "Amazon Machine Image ID"
    type        = string
    default     = "ami-04dd23e62ed049936"  
}