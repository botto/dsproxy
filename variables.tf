variable "subnet" {
  type        = string
  description = "IP Address of your subnet"
  default     = "192.168.178.0/24"
}

variable "subnet_az" {
  type        = string
  description = "Subnet region to deploy the proxy in"
  default     = "eu-west-2a"
}

variable "region" {
  type        = string
  description = "AWS Region to use"
  default     = "eu-west-2"
}

variable "aws_profile" {
  type        = string
  description = "Which AWS credentials profile to use"
  default     = "default"
}

variable "aws_profile_credentials" {
  type        = string
  description = "Location of the credentials file"
  default     = "~/.aws/credentials"
}

variable "namespace" {
  type        = string
  description = "A namespace to seperate your AWS resources"
  default     = "dsproxy"
}

variable "ssh_keys" {
  type        = list(string)
  description = "SSH Keys to add to primary user"
}

variable "wireguard_conf_path" {
  type        = string
  description = "Path to the wireguard configuration file"
  default     = "./files/wg0.conf"
}

variable "sniproxy_conf_path" {
  type        = string
  description = "Path to sniproxy configuration file"
  default     = "./files/sniproxy.conf"
}

variable "eip_id" {
  type        = string
  description = "ID for elastic ip to use with domain name for more pemanant ip"
}