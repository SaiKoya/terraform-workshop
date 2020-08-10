variable "prefix" {
  type = string
  default = "jb"
}

locals {
  resource_group_name = "${var.prefix}-my-rg"
  storage_account_name = "${var.prefix}mystrx9102"
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "example" {
  name = local.resource_group_name
}

resource "azurerm_storage_account" "example" {
  name                     = local.storage_account_name
  resource_group_name      = data.azurerm_resource_group.example.name
  location                 = data.azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    terraform = true
  }
}

resource "azurerm_storage_container" "example" {
  name                  = "mycontainer"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

output "storage_account_name" {
  value = local.storage_account_name
}

output "container_name" {
  value = azurerm_storage_container.example.name
}