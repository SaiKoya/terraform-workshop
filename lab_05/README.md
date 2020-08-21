# Lab 05 - Count and For_Each

## Lab Overview

In this lab, you will use the count and for_each keywords to create multiple resources.

You will learn:

* How to create multiple resources with `count`
* How to use `for_each`
* How to use Terraform functions

## Lab Exercise

### Write Configuration Using Count

Change directory into a folder specific to this lab. For example: cd terraform-workshop/lab_05/.

> Authenticate as instructed by Lab 01 if necessary  
Ensure remote state is enabled as instructed by lab 03

Use the count keyword to create multiple resources.

```hcl
resource "azurerm_storage_account" "module" {
  count                    = 3
  # use count.index to ensure that the resource has a unique name
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

Navigate to `modules\messaging\main.tf` to make the following code changes.

This module will use the variable `enable_dead_lettering` as a flag to conditionally create resources. This is a useful technique when writing complex modules.

Use the local variables to set the queue list based on the value of `enable_dead_lettering`.

```hcl
locals {
    queue_list = var.enable_dead_lettering ? ["inbox", "outbox", "inbox-dl"] : ["inbox", "outbox"]
}
```

Use the `for_each` keyword and `toset` function to create the storage queues.

``` hcl
locals {
    queue_list= var.enable_dead_lettering ? ["inbox", "outbox", "inbox-dl"] : ["inbox", "outbox"]
}

resource "azurerm_storage_queue" "example" {
  for_each             = toset(local.queue_list)
  name                 = each.key
  storage_account_name = var.storage_account_name
}
```

Write the configuration for the module in `main.tf` by passing in the first storage account name created above using the element function.

```hcl
module "messaging" {
  source = "./modules/messaging"
  # use the first storage account name in the list
  storage_account_name = element(azurerm_storage_account.example.*.name, 0)
}
```

Run `terraform apply`.

After inspecting the results, modify the module by enabling dead lettering.

```hcl
module "messaging" {
  source = "./modules/messaging"
  # use the first storage account name in the list
  storage_account_name = element(azurerm_storage_account.example.*.name, 0)
  enable_dead_lettering = true
}
```

Run `terraform apply` again.  Notice that Terraform only creates the delta between the declared state of resources and what exists in the state file.

Run `terraform destroy` to clean up resources.

## Advanced Areas to Explore

1. Explore the [functions](https://www.terraform.io/docs/configuration/functions.html) that are available

## Resources

[Functions](https://www.terraform.io/docs/configuration/functions.html)
