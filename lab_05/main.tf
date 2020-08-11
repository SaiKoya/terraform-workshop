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


resource "azurerm_storage_account" "example" {
  count                    = 3
  name                     = "${local.storage_account_name}${count.index + 1}"
  resource_group_name      = data.azurerm_resource_group.example.name
  location                 = data.azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
      Name = "Storage Account ${count.index + 1}"
  }
}

module "messaging" {
  ## path is slightly different than lab due to folder structure
  source = "./modules/messaging"
  # use the first storage account name in the list
  storage_account_name = element(azurerm_storage_account.example.*.name, 0)
}

