variable "prefix" {
  description = "Prefix for Azure resoureces"
}

variable "rg_location" {
    description = "location of resource group"
}

variable "dns_servers" {
    description = "list the required dns servers (i.e. 10.10.0.11, 10.10.0.12)"
}

variable "vnet_addressspace" {
    description = "input the address space for the main virtual network. Use a /21 to allow enough Private IPs. (i.e. 10.10.0.0/21)"
}

variable "subnet0" {
    description = "Input the base infrastructure subnet. This is where all IaaS will sit. (i.e. 10.10.0.0/24)"
}

variable "subnet1" {
    description = "Input the Azure Virtual Desktops subnet. This is where all virtual session hosts will sit. (i.e. 10.10.2.0/24)"
}

variable "bastion_subnet" {
    description = "Input the bastion subnet (i.e. 10.10.5.0/24)"
}

variable "dc01_ip" {
    description =  "Input the static IP Address of the domain controller in Azure (i.e. 10.10.0.11)"
}

variable "vm_adminuser" {
    description = "Input local admin account. Note: Make sure to note password in pwstate"
}

variable "vm_adminpassword" {
    type = string
    sensitive = true 
    description = "Input local admin password."
}

variable "rfc3339" {
    type        = string
    default     = "2022-08-15T12:00:00Z"
    description = "Registration token expiration"
}
