provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "jb-my-rg"
  location = "eastus"

  tags = {
    terraform = "true"
  }
}