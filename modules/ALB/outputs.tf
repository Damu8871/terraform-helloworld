output "alb_target_group_id" {
	value = "${aws_alb_target_group.test.id}"
}

output "alb_listener_deps" {
	value = "${aws_alb_listener.front_end.*}"
}
