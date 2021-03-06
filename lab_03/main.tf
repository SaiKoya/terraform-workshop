variable "prefix" {
  type    = string
}

terraform {
  backend "azurerm" {
    resource_group_name  = "<Add resource group name>"
    storage_account_name = "<Add storage account name>"
    container_name       = "<Add container name>"
    key                  = "terraform.tfstate"
  }
}

locals {
  resource_group_name   = "${var.prefix}-my-rg"
  app_service_plan_name = "${var.prefix}-lab-app-plan"
  azure_function_name   = "${var.prefix}-lab-fn"
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "example" {
  name = local.resource_group_name
}

data "azurerm_storage_account" "example" {
  name                = "${var.prefix}mystrx9102"
  resource_group_name = data.azurerm_resource_group.example.name
}

resource "azurerm_app_service_plan" "example" {
  name                = local.app_service_plan_name
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "example" {
  name                       = local.azure_function_name
  location                   = data.azurerm_resource_group.example.location
  resource_group_name        = data.azurerm_resource_group.example.name
  app_service_plan_id        = azurerm_app_service_plan.example.id
  storage_account_name       = data.azurerm_storage_account.example.name
  storage_account_access_key = data.azurerm_storage_account.example.primary_access_key
}
