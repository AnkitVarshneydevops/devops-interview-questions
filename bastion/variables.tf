variable "name" {
  description = "Name of the project"
}

variable "environment" {
  description = "Environment Type"
}

/* variable "key_name" {
  description = "Private key"
} */

variable "instance_type" {
  description = "Backend-Prod server type"
}
variable "vpc" {
  type        = string
  description = "vpc"
}

variable "public_subnet_id" {}

variable "aws_region" {}

variable "ec2_sg_group_id" {}


