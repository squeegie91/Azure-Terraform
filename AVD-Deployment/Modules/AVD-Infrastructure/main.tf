terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

provider "azurerm" {
  features {}
}

## Create Main Infratructure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-infa-rg"
  location = var.rg_location
  tags = {
    Environment = "test"
    Source = "Terraform"
    Application = "AVD"
    Engineer = "Luigi Arroyo"
    Deployment = "modules"
    ProductType = "Infrastructure"
  }
}

## Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name = "${var.prefix}-vnet"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = [var.vnet_addressspace]
  dns_servers = [var.dns_servers]

  tags = {
    Environment = "test"
    Source = "Terraform"
    Application = "AVD"
    Engineer = "Luigi Arroyo"
    Deployment = "modules"
    ProductType = "Infrastructure"
  }
}

## Create Infrastructure Server Subnet
resource "azurerm_subnet" "subnet0" {
  name = "${var.prefix}-INFRA"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.subnet0]
}

## Create AVD Session Host Subnet
resource "azurerm_subnet" "subnet1" {
  name = "${var.prefix}-AVD"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.subnet1]
}

## Create Bastion Subnet for remote connectivity
resource "azurerm_subnet" "bastion" {
  name = "AzureBastionSubnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.bastion_subnet]
}

## Create Primary Public IP for Outbound
resource "azurerm_public_ip" "publicip" {
  name = "${var.prefix}-PIP"
  resource_group_name = azurerm_resource_group.rg.name
  location =  azurerm_resource_group.rg.location
  allocation_method = "Dynamic"  
}

## Create Primary Public IP for Bastion Network
resource "azurerm_public_ip" "bastion_pip" {
  name = "${var.prefix}-BPIP"
  resource_group_name = azurerm_resource_group.rg.name
  location =  azurerm_resource_group.rg.location
  allocation_method = "Static"
  sku = "Standard"
}

## Create New Domain Controller and Configurations
resource "azurerm_network_interface" "vNIC" {
  name = "${var.prefix}-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "${var.prefix}-config" 
    subnet_id = azurerm_subnet.subnet0.id
    private_ip_address_allocation = "static"
    private_ip_address = "${var.dc01_ip}"
  }
}

resource "azurerm_windows_virtual_machine" "dc01" {
  name = "${var.prefix}dc01"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size = "Standard_D2s_v4"
  admin_username = "${var.vm_adminuser}"
  admin_password = "${var.vm_adminpassword}"
  network_interface_ids = [ azurerm_network_interface.vNIC.id ]

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2022-datacenter-g2"
    version = "latest"
  }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  tags = {
    Environment = "test"
    Source = "Terraform"
    Application = "AVD"
    Engineer = "Luigi Arroyo"
    Deployment = "modules"
    ProductType = "Infrastructure"
  }

}

resource "azurerm_bastion_host" "BastionHost" {
  name = "${var.prefix}-bastion"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name  = "${var.prefix}-bastion-config"
    subnet_id = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
  tags = {
    Environment = "test"
    Source = "Terraform"
    Application = "AVD"
    Engineer = "Luigi Arroyo"
    Deployment = "modules"
    ProductType = "Infrastructure"
  }
}

