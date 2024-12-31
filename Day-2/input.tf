variable "vpc_cidr" {
  type = string
}

variable "ports" {
  type    = list(string)
  default = ["22", "80", "443"]
}

variable "subnet_names" {
  type    = list(string)
  default = ["PUBLIC_SUBNET", "PRIVATE_SUBNET"]
}

variable "subnet_cidr" {
  type    = list(string)
  default = ["10.0.0.0/25", "10.0.0.128/25"]

}

