variable "subscription_id" {
}
variable "client_id" {
}
variable "client_secret" {
}
variable "tenant_id" {
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
# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "anil-terraform-resourceGroup"
  location = "West Europe"
}
# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}
