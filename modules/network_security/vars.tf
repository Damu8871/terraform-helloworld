variable "region" {
  default = "ap-south-1"
}

variable "vpc_cidr"{
  default = "10.0.0.0/16"
}

variable "tenancy"
{
  default = "default"
}

variable "tagname_vpc" {
  default = "testVPC"
}

variable "tagname_subnet" {
  default = "testSubnet"
}

variable "subnet_cidr"{
  default = "10.0.1.0/24"
}

variable "azs_count"{
  default ="2"
}
