output "iam_role_for_ecs" {
	value = "${aws_iam_role.ecs_service.name}"
}

output "iam_role_policy_name" {
	value = "${aws_iam_role_policy.ecs_service.*}"
}

output "instance_profile_name" {
	value = "${aws_iam_instance_profile.app.name}"
}


