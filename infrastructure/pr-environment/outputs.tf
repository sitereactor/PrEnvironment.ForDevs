output "resource_group" {
    value = azurerm_resource_group.rg_pr_test.name
    description = "Resource Group used for the WebApp"
}

output "resource_group_location" {
    value = azurerm_resource_group.rg_pr_test.location
    description = "Location of the Resource Group used for the WebApp"
}

output "app_insights" {
    value = azurerm_application_insights.pr_test_webapp.instrumentation_key
    description = "Instrumentation Key for application insights"
}

output "pr_webapp" {
    value = azurerm_app_service.pr_test_webapp.name
    description = "Name of the App Service WebApp"
}

output "pr_webapp_url" {
    value = azurerm_app_service.pr_test_webapp.default_site_hostname
    description = "Name of the App Service WebApp"
}