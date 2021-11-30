terraform {
  required_version = ">=1.0"
  required_providers {
    azurerm = "=2.46.0"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "2096effc-2d11-43cf-852e-183248b318b5"
  tenant_id       = "55119d9b-fd55-4e05-a9b6-b00e9a8b0b13"

}


