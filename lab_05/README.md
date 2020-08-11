# Lab 05 - Count and For_Each

## Lab Overview

In this lab, you will learn:

* How to create multiple resources with `count`
* How to use `for_each`

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

Navigate to `modules\messaging\main.tf` to make the following code changes.

This module will use a variable as a flag to conditionally create resources. This is a useful technique when writing complex modules.

Use the local variables to set the queue list based on if the variable is enabled.

```hcl
locals {
    queue_list= var.enable_dead_lettering ? ["inbox", "outbox", "inbox-dl"] : ["inbox", "outbox"]
}
```

Use the `for_each` keyword and the element function to create queues for the first storage account resource.

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

Use the module in `main.tf` by passing in the first storage account name created above.

```hcl
module "messaging" {
  source = "../modules/messaging"
  # use the first storage account name in the list
  storage_account_name = element(azurerm_storage_account.example.*.name, 0)
}
```

Run terraform apply.

After inspecting the results, modify the module by enabling dead lettering.

```hcl
module "messaging" {
  source = "../modules/messaging"
  # use the first storage account name in the list
  storage_account_name = element(azurerm_storage_account.example.*.name, 0)
  enable_dead_lettering = true
}
```

Run Terraform plan and apply again.  Notice that Terraform only creates the delta between declared state of resources and what exists in the state file.

Run Terraform Destroy to clean up resources.

## Resources

[Functions](https://www.terraform.io/docs/configuration/functions.html)