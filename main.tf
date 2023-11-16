resource "random_pet" "pet" {
  count = var.subscription_name == null ? 1 : 0
}

data "azurerm_billing_mca_account_scope" "scope" {
  billing_account_name = var.billing_account_name
  billing_profile_name = var.billing_profile_name
  invoice_section_name = var.invoice_section_name

}

resource "azurerm_subscription" "sub" {
  subscription_name = var.subscription_name == null ? random_pet.pet[0].id : var.subscription_name
  billing_scope_id  = data.azurerm_billing_mca_account_scope.scope.id
}

data "azuread_client_config" "current" {}

resource "azuread_application" "example" {
  display_name = "SP-${coalesce(var.subscription_name, random_pet.pet[0].id)}"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "example" {
  client_id                    = azuread_application.example.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "name" {
  scope                = "/subscriptions/${azurerm_subscription.sub.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.example.object_id
}

resource "azurerm_resource_group" "name" {
  provider = azurerm.new-sub
  name     = "RSG-${coalesce(var.subscription_name, random_pet.pet[0].id)}"
  location = "centralus"
}

resource "azurerm_resource_provider_registration" "rp_registration" {
  provider = azurerm.new-sub
  name     = "Microsoft.ContainerService"
}