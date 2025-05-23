terraform {
  backend "s3" {
    bucket  = "tf-state-devops-2025"
    key     = "infra.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
