terraform {
  backend "s3" {
    bucket = "kms-tfstate"
    key    = "terraform.tfstate"
    region = "eu-central-1"
    endpoints = {
      s3 = "https://s3.minio.kms.r0chd.pl"
    }

    use_path_style              = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
  }
}
