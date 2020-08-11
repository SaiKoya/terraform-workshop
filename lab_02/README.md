# Lab 02 - Data Sources, Variables, and Outputs

## Lab Overview

In this lab, you are going to add new Azure resources to the resource group created in the previous lab.

You will learn:

* How to use a data source
* How to use variables and outputs
* String interpolation

## Lab Exercise

### Variables

Change directory into a folder specific to this lab. For example: `cd terraform-workshop/lab_02/`.

> Authenticate as instructed by [Lab 01]("../../../lab_01/README.md) if necessary

Add an input variable so that a prefix can be passed in and used for naming resources.

``` hcl
variable "prefix" {}
```

Create a locals variable block. In this block we are going to define local variables and use string interpolation to build resource names.

Use the `prefix` input variable to create a resource group name and storage account name that will be used to name the resources.

``` hcl
locals {
  resource_group_name = "${var.prefix}-my-rg"

  # this storage account name will need to be unique
  storage_account_name = "${var.prefix}mystrx9102"
}
```

> Note: Azure Storage accounts need to be globally unique

### Data Source

Use the terraform `data source` block instead of the resource block.  The `data source` allows Terraform configuration to make use of information defined outside of Terraform, or defined by another Terraform Configuration.

``` hcl
data "azurerm_resource_group" "example" {
  name = local.resource_group_name
}
```

### Write Configuration For Resources

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

## Write Configuration Outputs

Output values are like the return values of a Terraform module.

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

When executing the Terraform plan and apply, supply the variable `prefix`.

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

## Advanced Areas to Explore

1. Use -var-file to pass variables using a `tfvars` file
2. Supply variable type, description, and default values
3. Explore variable definition precedence

## Resources

* [Terraform Variables](https://www.terraform.io/docs/configuration/variables.html)
* [Terraform Output Values](https://www.terraform.io/docs/configuration/outputs.html)