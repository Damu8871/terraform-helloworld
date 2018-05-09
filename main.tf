provider "aws" {
	region = "ap-south-1"
}
module "network_security" {
	source = "modules/network_security"
}
module "security_groups" {
	source = "modules/security_groups"
	vpc_id = "${module.network_security.vpc_id}"
}
module "cloudwatch_logs" {
	source = "modules/Cloudwatch"
}
module "IAM" {
        source = "modules/IAM"
        app_log_group_arn = "${module.cloudwatch_logs.app_log_group_arn}"
        ecs_log_group_arn = "${module.cloudwatch_logs.ecs_log_group_arn}"
}
module "ALB" {
        source = "modules/ALB"
        vpc_id = "${module.network_security.vpc_id}"
        loadBalancer_SG_id = "${module.security_groups.loadBalancer_SG_id}"
        public_subnet_ids = "${module.network_security.public_subnet_ids}"
}
module "ECS" {
	source = "modules/ECS"
	log_group_name = "${module.cloudwatch_logs.log_group_app_name}"
	iam_role_for_ecs = "${module.IAM.iam_role_for_ecs}"
	alb_target_group_id = "${module.ALB.alb_target_group_id}"
	alb_listener_deps = "${module.ALB.alb_listener_deps}"
	iam_role_policy_name = "${module.IAM.iam_role_policy_name}"
}
module "Compute-ASG" {
	source = "modules/compute-asg"
	private_subnet_ids = "${module.network_security.private_subnet_ids}"	
	cluster_name = "${module.ECS.cluster_name}"
	ecs_log_group_name = "${module.cloudwatch_logs.ecs_log_group_name}"
	instance_sg = "${module.security_groups.instance_sg}"
	instance_profile_name = "${module.IAM.instance_profile_name}"
}
