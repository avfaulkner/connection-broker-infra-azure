variable "owner" {
  default     = ""
  description = "owner of the resource"
}

variable "region" {
  description = "Region to place the infrastructure"
}

variable "instance_name" {
  type        = string
  description = "Name of your instance"
}

variable "admin_username" {
  type        = string
  description = "Instance user name"
}

variable "admin_password" {
  type        = string
  description = "Instance user password"
}

variable "dbadmin_username" {
  type        = string
  description = "Database admin name"
}

variable "dbadmin_password" {
  type        = string
  description = "Database admin password"
}

variable "ssh_cidr_blocks" {
  type        = list
  description = "List of cidr blocks which can ssh into host instances"
}

variable "destination_address_prefix" {
  type        = list
  description = "outbound address for security group rules"
}

variable "computer_name_prefix" {
  type        = string
  description = "Name of your scale set instances"
}

variable "ssh_pub_key_path" {
  description = "SSH key for Leostream Broker"
}

variable "virtual_network" {
  description = "Address space for virtual network"
  default     = ["10.0.0.0/16"]
}

variable "scale_set_subnet_backend" {
  description = "CIDR for scale set private subnet"
}

variable "scale_set_subnet_frontend" {
  description = "CIDR for scale set private subnet"
}

variable "desktop_subnet_private" {
  description = "Subnet for remote desktops"
}

variable "db_subnet_private" {
  description = "Database private subnet"
}