variable "owner" {
  default     = ""
  description = "owner of the resource"
}

variable "region" {
  description = "Region to place the infrastructure"
}

variable "env" {
  description = "Environment in which to place the infrastructure"
}

variable "language" {
  description = "Language used in VM"
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

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "ssh_cidr_blocks" {
  description = "List of cidr blocks which can ssh into host instances"
}

variable "destination_address_prefix" {
  type        = list(any)
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

variable "broker_subnet" {
  description = "CIDR for broker subnet"
}

variable "gateway-subnet-frontend" {
  description = "CIDR for app gateway frontend subnet"
}

variable "desktop_subnet_private" {
  description = "Subnet for remote desktops"
}

variable "db_subnet_private" {
  description = "Database private subnet"
}

variable "gateway_subnet" {
  description = "Gateway subnet"
}

variable "bastion_subnet" {
  description = "CIDR for bastion subnet"
}

variable "identity_ids" {
  description = "Instances given the UserAssigned identity type must have at least one identity ID assigned to it"
}

variable "license_subnet" {
  description = "Subnet for license server"
}

variable "broker_lb_domain_name_label" {
  description = "DNS name for broker load balancer"
}