resource "azurerm_resource_group" "rg_pr_test" {
  name     = "rg-pr-${var.pr_number}-${var.location_infix}-${var.env_suffix}"
  location = var.default_location
}

#Generate Password
resource "random_password" "sql_password" {
  length           = 42
  special          = true
  override_special = "$%@&*()"
}

#Azure SQL Server
resource "azurerm_sql_server" "pr_test_sql_server" {
  name                              = "mssql-pr-${var.pr_number}-${var.location_infix}-${var.env_suffix}"
  resource_group_name               = azurerm_resource_group.rg_pr_test.name
  location                          = azurerm_resource_group.rg_pr_test.location
  version                           = "12.0"
  administrator_login               = var.sql_username
  administrator_login_password      = random_password.sql_password.result
}

resource "azurerm_sql_firewall_rule" "pr_test_sql_server_firewall" {
  name                = "PrFirewallRule"
  resource_group_name = azurerm_resource_group.rg_pr_test.name
  server_name         = azurerm_sql_server.pr_test_sql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

#Serverless Database
resource "azurerm_sql_database" "pr_test_sql_database" {
  name                = "sqldbtestpr${var.pr_number}"
  resource_group_name = azurerm_resource_group.rg_pr_test.name
  location            = azurerm_resource_group.rg_pr_test.location
  server_name         = azurerm_sql_server.pr_test_sql_server.name

  create_mode                       = "Default"
  edition                           = "GeneralPurpose"
  max_size_bytes                    = "34359738368"
  requested_service_objective_name  = "GP_S_Gen5_2"
  collation                         = "SQL_Latin1_General_CP1_CI_AS"
}

#Application Insights
resource "azurerm_application_insights" "pr_test_webapp" {
  name                = "azappins-pr-${var.pr_number}-${var.location_infix}-${var.env_suffix}"
  resource_group_name = azurerm_resource_group.rg_pr_test.name
  location            = azurerm_resource_group.rg_pr_test.location
  application_type    = "web"
}

#App Service Plan - shared tier
resource "azurerm_app_service_plan" "pr_test_webapp" {
  name                = "azappsvc-pr-${var.pr_number}-${var.location_infix}-${var.env_suffix}"
  resource_group_name = azurerm_resource_group.rg_pr_test.name
  location            = azurerm_resource_group.rg_pr_test.location
  reserved            = false

  sku {
    tier = "Basic"
    size = "B1"
  }
}

#App Service WebApp
resource "azurerm_app_service" "pr_test_webapp" {
  name                        = "azweb-pr-${var.pr_number}-${var.location_infix}-${var.env_suffix}"
  resource_group_name         = azurerm_resource_group.rg_pr_test.name
  location                    = azurerm_resource_group.rg_pr_test.location
  app_service_plan_id         = azurerm_app_service_plan.pr_test_webapp.id
  
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.pr_test_webapp.instrumentation_key
    "WEBSITE_RUN_FROM_PACKAGE"       = "0"
  }

  connection_string {
    name  = "umbracoDbDSN"
    type  = "SQLServer"
    value = "Server=${azurerm_sql_server.pr_test_sql_server.fully_qualified_domain_name},1433;Database=${azurerm_sql_database.pr_test_sql_database.name};User ID=${var.sql_username}@${azurerm_sql_database.pr_test_sql_database.name};Password=${random_password.sql_password.result};Trusted_Connection=False;Encrypt=True;"
  }

  https_only              = true
  client_affinity_enabled = false

  site_config {
    always_on       = true
    min_tls_version = "1.2"
    http2_enabled   = true
    scm_type        = "VSTSRM"
  }

  depends_on = [
    azurerm_sql_database.pr_test_sql_database,
    azurerm_application_insights.pr_test_webapp
  ]
}