variable "elb_target_group_name" {
	default = "nj-ecs-hellonode"	
}

variable "vpc_id" {}

variable "loadBalancer_SG_id" {}

variable "public_subnet_ids" {}

variable "alb_name" {
	default = "tf-test-alb-hellonode"
}
