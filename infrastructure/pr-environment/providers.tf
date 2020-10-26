terraform {
  required_version = ">= 0.12.20"
  backend "azurerm" {
      resource_group_name   = "rg-stor-we-test-pr"
      storage_account_name  = "terraformwetestpr"
      container_name        = "terraform"
      key                   = "#{terraform_state_key}"
      access_key            = "#{terraform_access_key}"
  }
}

provider "azurerm" {
  version         = "=2.12.0"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features  {}
}
