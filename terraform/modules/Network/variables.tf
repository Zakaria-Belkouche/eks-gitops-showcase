variable "vpc_cidr" {
  type = string
}

variable "privatesubnet_cidrs" {
  type = map(string)
}

variable "publicsubnet_cidrs" {
  type = map(string)
}

variable "subnet_az" {
  type = map(string)
}
