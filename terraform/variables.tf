variable "region" {
  description = "Region in which to build the resource."
  default     = "ap-northeast-1"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The IP address range of the VPC in CIDR notation."
  default     = "10.0.0.0/16"
  type        = string
}

variable "customer_gateway_ip" {
  description = "Global IP to be used."
  type        = string
}

variable "home_network_cidr" {
  description = "Home network CIDR."
  default     = "192.168.100.0/24"
  type        = string
}
