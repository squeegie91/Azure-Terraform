provider "azurerm" {
  features {}
}
module "avd-infrastructure" {
    source = "./Modules/AVD-Infrastructure"
    rg_location = "${var.rg_location}"
    prefix = "${var.prefix}"
    dns_servers = "${var.dns_servers}"
    vnet_addressspace = "${var.vnet_addressspace}"
    subnet0 = "${var.subnet0}"
    subnet1 = "${var.subnet1}"
    bastion_subnet = "${var.bastion_subnet}"
    dc01_ip = "${var.dc01_ip}"
    vm_adminpassword = "${var.vm_adminpassword}"
    vm_adminuser = "${var.vm_adminuser}"
}

module "avd-vdi" {
    source = "./Modules/AVD-VDI"
    rg_location = "${var.rg_location}"
    prefix = "${var.prefix}"
}

module "avd-storage" {
    source = "./Modules/AVD-Storage"
    rg_location = "${var.rg_location}"
    prefix = "${var.prefix}"
    
}
module "avd-sig" {
    source = "./Modules/AVD-SharedImage"
    rg_location = "${var.rg_location}"
    prefix = "${var.prefix}"

}