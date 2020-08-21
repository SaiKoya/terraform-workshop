variable "prefix" {
  type    = string
  default = "jb"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "<Add resource group name>"
    storage_account_name = "<Add storage account name>"
    container_name       = "<Add container name>"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

locals {
  resource_group_name   = "${var.prefix}-my-rg"
}

data "azurerm_resource_group" "example" {
  name = local.resource_group_name
}
