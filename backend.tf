terraform {
  backend "remote" {
    organization = "pkham"

    workspaces {
      name = "DEV"
    }   
  }
}