variable "subscription_id" {
}
variable "client_id" {
}
variable "client_secret" {
}
variable "tenant_id" {
}
variable "resource_group" {
}
variable "web_app" {
}
variable "deployment_slot" {
}

# Configure the Azure Provider
provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=2.4.0"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

output "subId" {
  value = "${var.subscription_id}"
}

output "resourceGroup" {
  value = "${var.resource_group}"
}

output "webApp" {
  value = "${var.web_app}"
}

output "deploymentSlot" {
  value = "${var.deployment_slot}"
}
