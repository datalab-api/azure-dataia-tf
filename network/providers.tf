# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
# This line specifies the version of the Azure Terraform provider we're using
provider "azurerm" {
  features {} # Optional block for future features

  # client_id       = "39531726-6255-4a6d-be23-1e4b1307d6ef"
  # client_secret   = "BL-8Q~I2diK2m3yBrkmMyNN_BKeZ.aS_3D5gydeW"
  # subscription_id = "84f1e4ea-8554-43e1-8709-f0b8589ea118"
  # tenant        = "<your_tenant_id>"  # Optional, if needed
}
