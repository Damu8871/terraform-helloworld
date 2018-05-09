output "loadBalancer_SG_id" {
	value = "${aws_security_group.loadBalancer_SG.id}"
}

output "instance_sg" {
	value = "${aws_security_group.Instance_sg.id}"
}
