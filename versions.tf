terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.45"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1"
    }
  }
}
