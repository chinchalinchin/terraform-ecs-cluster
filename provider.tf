terraform {
  required_version = ">= 1.2.6" 
  
#   backend "s3" {
#     ### This configuration is only for Demo Purposes - You should use your existing TF State Management configuration ###
#     bucket = "terraform-state-wam"
#     key    = "demo"
#     region = "us-east-1"
#   }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.25"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.0"
    }
    time = {
      source = "hashicorp/time"
      version = "~>0.7.2"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "aws" {
  region = var.region

  ### Commented out For Demo - Use this Block for integration into an existing Terraform implementation if you already have predefined role ###

  # assume_role {
  #     role_arn = "arn:aws:iam::${var.target_account_id}:role/${var.target_role_name}"
  #     session_name = "Terraform"
  # }
}