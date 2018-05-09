resource "aws_alb_target_group" "test" {
  name     = "${var.elb_target_group_name}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_alb" "main" {
  name            = "${var.alb_name}"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${var.loadBalancer_SG_id}"]
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.test.id}"
    type             = "forward"
  }
}
