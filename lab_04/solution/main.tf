variable "prefix" {
  type    = string
  default = "jb"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "jb-my-rg"
    storage_account_name = "jbmystrx9102"
    container_name       = "mycontainer"
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

module "my_azure_function" {
  source              = "../modules/isolated_azure_function"
  prefix              = var.prefix
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
}

# Bonus Solution
#module "my_azure_function" {
#  source              = "github.com/joelbrinkley/terraform-workshop/lab_04/modules/isolated_azure_function"
#  prefix              = var.prefix
#  location            = data.azurerm_resource_group.example.location
#  resource_group_name = data.azurerm_resource_group.example.name
#}

output "azure_function_name" {
  value = module.my_azure_function.azure_function_name
}