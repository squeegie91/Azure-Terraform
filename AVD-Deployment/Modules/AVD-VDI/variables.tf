variable "prefix" {
  description = "Prefix for Azure resoureces"
}

variable "rg_location" {
    description = "location of resource group"
}


variable "rfc3339" {
    type        = string
    default     = "2022-08-15T12:00:00Z"
    description = "Registration token expiration"
}

