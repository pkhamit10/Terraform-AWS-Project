terraform {
  required_version = ">= 1.12"

  backend "remote" {
    organization = "pkham"

    workspaces {
      prefix = "tf-"  # Terraform Cloud workspaces: tf-dev, tf-staging, tf-prod
    }
  }
}