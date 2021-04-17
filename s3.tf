terraform {
  backend "s3" {
    bucket = "nus-iss-equeue-terraform"
    key    = "database/tfstate"
    region = "us-east-1"
  }
}