# Lab 05 - Loops and Dynamic Blocks

## Lab Overview

In this lab, you will learn:

* How to create multiple resources with `count`
* How to use `for_each`
* How to build dynamic blocks

## Lab Exercise

### Get Started

* Change directory into a folder specific to this lab.
* For example: `cd terraform-workshop/lab_05/`.
* Authenticate as instructed by [Lab 01]("../../../lab_01/README.md) if necessary
* Ensure that the resources created [Lab 02]("../../../lab_02/README.md) still exist
* Ensure that the remote state is configured [Lab 03]("../../../lab_03/README.md) still exist

### Count

Use the count keyword to create multiple resources.

```hcl
resource "azurerm_storage_account" "module" {
  count                    = 3
  name                     = "${local.storage_account_name}${count.index}"
  resource_group_name      = data.azurerm_resource_group.example.name
  location                 = data.azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
      Name = "Storage Account ${count.index}"
  }
}
```

## For Each

Use the `for_each` keyword and the element function to create queues for the first storage account resource.

``` hcl
resource "azurerm_storage_queue" "example" {
  for_each             = toset( ["inbox", "outbox"] )
  name                 = each.key
  storage_account_name = element(azurerm_storage_account.example.*.name, 0)
}
```

## Resources

[Functions](https://www.terraform.io/docs/configuration/functions.html)