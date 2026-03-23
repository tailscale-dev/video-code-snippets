terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "example/terraform.tfstate"
    region = "garage"

    # Credentials and endpoint loaded from backend.hcl (gitignored)
    # cp backend.hcl.example backend.hcl and fill in your values, then: just init

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}
