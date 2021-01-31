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

resource "azurerm_resource_group" "main" {
  name     = "suhas-terraform-resourceGroup-test"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "main" {
  name                = "suhas-AppServicePlan-Terraform-test-windowss"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Windows"
  reserved            = true

  sku {
    tier = "Premium"
    size = "P1"
  }
}

resource "azurerm_app_service" "main" {
  name                = "suhas-WebApp-Terraform-test"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id

  site_config {
    linux_fx_version = "DOCKER|mcr.microsoft.com/appsvc/staticsite:latest"
    always_on        = "true"
  }
  
  app_settings = {
    "production_key" = "production_value"
     WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}

resource "azurerm_app_service_slot" "example" {
  name                = "terraformStage"
  app_service_name    = azurerm_app_service.main.name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id

  site_config {
    linux_fx_version = "DOCKER|mcr.microsoft.com/appsvc/staticsite:latest"
    always_on        = "true"
  }
  
  app_settings = {
    "stage_key" = "stage_value"
     WEBSITES_ENABLE_APP_SERVICE_STORAGE = false

#     /*
#     Settings for private Container Registires  
#     DOCKER_REGISTRY_SERVER_URL      = ""
#     DOCKER_REGISTRY_SERVER_USERNAME = ""
#     DOCKER_REGISTRY_SERVER_PASSWORD = ""
#     */
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI-stage"
  }
}

output "subId" {
  value = "${var.subscription_id}"
}

output "resourceGroup" {
  value = "${azurerm_resource_group.main.name}"
}

output "webApp" {
  value = "${azurerm_app_service.main.name}"
}

output "deploymentSlot" {
  value = "${azurerm_app_service_slot.example.name}"
}
