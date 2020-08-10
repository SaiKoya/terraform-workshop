# Lab 02 - Data Sources, Variables, and Outputs

## Lab Overview

In this lab, you will learn:

* How to use a data source
* How to use variables and outputs
* String interpolation
  
---

## Lab Exercise

### Get Started

* Change directory into a folder specific to this lab.
* For example: `cd terraform-workshop/lab_02/`.
* Create a file named `main.tf`
* Authenticate as instructed by [Lab 01]("../../../lab_01/README.md) if necessary

### Add the AzureRm Provider

``` hcl
provider "azurerm" {
  features {}
}
```

### Input Variables

Add a variable so that a prefix can be passed in and used for naming resources.

``` hcl
variable "prefix" {}
```

### Local Variables

Create a locals variable block. In this block we are going to define local variables and use string interpolation to build resource names.

In this block, we will leverage the `prefix` input variable to create a resource group name and storage account name that will be used by our resources.

``` hcl
locals {
  resource_group_name = "${var.prefix}-my-rg"

  # this storage account name will need to be unique
  storage_account_name = "${var.prefix}mystrx9102"
}
```

### Data Source

Use the terraform data source block instead of the resource block.  This block gives us access to the resource that is not managed by the Terraform state file.

``` hcl
data "azurerm_resource_group" "example" {
  name = local.resource_group_name
}
```

### Create Resources

``` hcl
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
```

## Outputs

Add output blocks for the storage account name and container name.

``` hcl
output "storage_account_name" {
  value = local.storage_account_name
}

output "container_name" {
  value = azurerm_storage_container.example.name
}
```

## Run Terraform Workflow

Run the Terraform workflow as described in lab 01.

When executing the Terraform plan and apply, we will supply the variable `prefix`.

``` sh
terraform init

terraform plan -var 'prefix=jb'

terraform apply -var 'prefix=jb'
```

Notice that the output variables are appended to the apply output.

<details><summary>View Output</summary>
<p>

``` sh
...
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

container_name = mycontainer
storage_account_name = jbmystrx9102
```

</p>
</details>

---

## List outputs

Use the Terraform output command to retrieve the output values defined in `main.tf`.

``` sh
terraform output
```

``` sh
$ terraform output
container_name = mycontainer
storage_account_name = jbmystrx9102
```

---

## Resources

* [Terraform Variables](https://www.terraform.io/docs/configuration/variables.html)
* [Terraform Output Values](https://www.terraform.io/docs/configuration/outputs.html)