terraform {
  backend "s3" {
    bucket       = "yosefi-terraform-bucket"
    key          = "terraform.tfstate"
    use_lockfile = true
    region       = "us-east-1"
  }
}