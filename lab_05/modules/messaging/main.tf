variable "storage_account_name" {
    type = string
    description = "The name of the storage account that the queues will be added"
}
variable "enable_dead_lettering" {
    type = bool
    description = "An optional flag that when set to true that will create a deadl letter queue."
    default = false
}

locals {
    queue_list= var.enable_dead_lettering ? ["inbox", "outbox", "inbox-dl"] : ["inbox", "outbox"]
}

resource "azurerm_storage_queue" "example" {
  for_each             = toset(local.queue_list)
  name                 = each.key
  storage_account_name = var.storage_account_name
}
