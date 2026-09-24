terraform {
  backend "s3" {
    key          = "terraform-aws-nginx/dev/terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
}
