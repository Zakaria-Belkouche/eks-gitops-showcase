variable "node_role_arn" {
  type = string
}

variable "desired_nodes" {
  type = number
}

variable "max_nodes" {
  type = number
}

variable "min_nodes" {
  type = number
}

variable "ng_instance_types" {
  type = list(string)
}

variable "ng_capacity_type" {
  type = string
}

variable "ng_disk_size" {
  type = number
}

variable "ng_ami_type" {
  type = string
}

variable "max_unavailable" {
  type = number
}

variable "node_sg" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}