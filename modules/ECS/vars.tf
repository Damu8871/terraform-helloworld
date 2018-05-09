variable "clustername" {
	default = "NodeJs Cluster"
}
variable "cluster_region" {
	default = "ap-south-1"
}
variable "log_group_name" {}

variable "image_url" {
	default = "rsridivya/helloworldnodejs:latest"
}

variable "container_name" {
	default = "hellonode"
}

variable "task-def-family" {
	default = "tf-example-hellonode-task-def"
}

variable "iam_role_for_ecs" {}

variable "alb_target_group_id" {}

variable "alb_listener_deps" {

}

variable "iam_role_policy_name" {

}

variable "deps" {default = [], type = "list"}

variable "ecs_service_name" {
	default = "tf-example-ecs-hellonode"
}
