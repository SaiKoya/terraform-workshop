variable "prefix" {}
variable "location" {}
variable "resource_group_name" {}

resource "random_string" "module" {
  length  = 6
  special = false
  upper   = false
}

locals {
  storage_account_name  = "${var.prefix}str${random_string.module.result}"
  app_service_plan_name = "${var.prefix}-lab-app-plan"
  azure_function_name   = "${var.prefix}-lab-fn"
}

resource "azurerm_storage_account" "module" {
  name                     = local.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "module" {
  name                = local.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "module" {
  name                       = local.azure_function_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_app_service_plan.module.id
  storage_account_name       = azurerm_storage_account.module.name
  storage_account_access_key = azurerm_storage_account.module.primary_access_key
}

output "azure_function_name" {
  value = local.azure_function_name
}

output "storage_account_name" {
  value = local.storage_account_name
}

output "app_service_plan_name" {
  value = local.app_service_plan_name
}