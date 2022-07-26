provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "sig" {
  location = var.rg_location
  name     = "${var.prefix}-sig-rg"
}
# Created Shared Image Gallery
resource "azurerm_shared_image_gallery" "sig" {
  name                = "sig${var.prefix}"
  resource_group_name = azurerm_resource_group.sig.name
  location            = azurerm_resource_group.sig.location
  description         = "master shared image"

    tags = {
    Environment = "test"
    Source = "Terraform"
    Application = "AVD"
    Engineer = "Luigi Arroyo"
  }
}

resource "azurerm_shared_image" "sig" {
  name                = "avd-image"
  gallery_name        = azurerm_shared_image_gallery.sig.name
  resource_group_name = azurerm_resource_group.sig.name
  location            = azurerm_resource_group.sig.location
  os_type             = "Windows"

  identifier {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "office-365"
    sku       = "20h2-evd-o365pp"
  }
}