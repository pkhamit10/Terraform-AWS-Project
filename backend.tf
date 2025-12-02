terraform {
  required_version = ">= 1.12"

  backend "remote" {
    organization = "pkham"

    workspaces {
      prefix = "tf-"  
    }
  }
}