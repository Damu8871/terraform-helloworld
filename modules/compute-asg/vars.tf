variable "key_name" {
  description = "Name of AWS key pair"
  default = "damodaran_test"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default     = "1"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default     = "2"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
  default     = "1"
}

variable "aws_autoscaling_group_name" {
	default = "tf-test-asg"
}

variable "private_subnet_ids" {}

variable "aws_region" {
	default = "ap-south-1"
}

variable "instance_sg" { }

variable "instance_profile_name" { }

variable "ecs_log_group_name" {}

variable "cluster_name" {}
