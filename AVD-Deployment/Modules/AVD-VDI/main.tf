provider "azurerm" {
  features {}
}

# Resource group name is output when execution plan is applied.
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-avd-rg"
  location = var.rg_location

  tags = {
    Environment = "test"
    Source = "Terraform"
    Application = "AVD"
    Engineer = "Luigi Arroyo"
    Deployment = "modules"
    ProductType = "VDI"
  }
}

# Create AVD workspace
resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = "${var.prefix}-workspace"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  friendly_name       = "${var.prefix} Workspace"
  description         = "${var.prefix} Workspace"
  
  tags = {
    Environment = "test"
    Source = "Terraform"
    Application = "AVD"
    Engineer = "Luigi Arroyo"
    Deployment = "modules"
    ProductType = "VDI"
  }
}

# Create AVD host pool
resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  name                     = "${var.prefix}-hp"
  friendly_name            = "${var.prefix}-hp"
  validate_environment     = true
  custom_rdp_properties    = "audiocapturemode:i:1;audiomode:i:0;targetaadjoined:i:1;"
  description              = "${var.prefix} HostPool"
  type                     = "Pooled"
  maximum_sessions_allowed = 20
  load_balancer_type       = "DepthFirst" #[BreadthFirst DepthFirst]

  tags = {
    Environment = "test"
    Source = "Terraform"
    Application = "AVD"
    Engineer = "Luigi Arroyo"
    Deployment = "modules"
    ProductType = "VDI"
  }
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "registrationinfo" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.hostpool.id
  expiration_date = var.rfc3339
}

# Create AVD DAG
resource "azurerm_virtual_desktop_application_group" "dag" {
  resource_group_name = azurerm_resource_group.rg.name
  host_pool_id        = azurerm_virtual_desktop_host_pool.hostpool.id
  location            = azurerm_resource_group.rg.location
  type                = "Desktop"
  name                = "${var.prefix}-dag"
  friendly_name       = "Desktop AppGroup"
  description         = "AVD application group"
  depends_on          = [azurerm_virtual_desktop_host_pool.hostpool, azurerm_virtual_desktop_workspace.workspace]

  tags = {
    Environment = "test"
    Source = "Terraform"
    Application = "AVD"
    Engineer = "Luigi Arroyo"
    Deployment = "modules"
    ProductType = "VDI"
  }
}

# Associate Workspace and DAG
resource "azurerm_virtual_desktop_workspace_application_group_association" "ws-dag" {
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
}