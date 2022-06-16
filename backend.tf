terraform {
  backend "s3" {
    bucket  = "miax-state-files"
    key     = "EKSPRIVATE/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    dynamodb_table = "dynamodb-state-locking"      
  }
}