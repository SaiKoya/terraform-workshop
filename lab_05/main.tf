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

resource "random_string" "example" {
  length  = 6
  special = false
  upper   = false
}

locals {
  resource_group_name   = "${var.prefix}-my-rg"
  storage_account_name  = "${var.prefix}str${random_string.example.result}"
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "example" {
  name = local.resource_group_name
}