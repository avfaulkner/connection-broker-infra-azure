variable "owner" {
  default = ""
  description = "owner of the resource"
}

variable "region" {
  description = "Region to place the infrastructure"
}

variable "instance_name" {
  type = string
  description = "Name of your instance"
}

variable "admin_username" {
  type = string
  description = "Instance user name"
}

variable "admin_password" {
  type = string
  description = "Instance user password"
}

variable "dbadmin_username" {
  type = string
  description = "Database admin name"
}

variable "dbadmin_password" {
  type = string
  description = "Database admin password"
}

variable "ssh_cidr_blocks" {
  type = list
  description = "List of cidr blocks which can ssh into host instances"
}

variable "destination_address_prefix" {
  type = list
  description = "outbound address for security group rules"
}

variable "computer_name_prefix" {
  type = string
  description = "Name of your scale set instances"
}
