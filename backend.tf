terraform {
  backend "s3" {
    bucket = "data-vpc-data"
    key    = "infrastructure/chiz-vpc.tfstate"
    region = "us-east-1"
  }
}