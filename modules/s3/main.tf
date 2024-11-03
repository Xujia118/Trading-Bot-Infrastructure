resource "aws_s3_bucket" "trading_bot_bucket" { 
    bucket = "stocks-trading-bucket"

    tags = {
        Name = "Trading Bot S3 Bucket"
        Environment = "Production" 
    }
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value = aws_s3_bucket.trading_bot_bucket.bucket
}