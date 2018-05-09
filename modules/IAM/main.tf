resource "aws_iam_role" "ecs_service" {
  name = "${var.ecs_service_role_name}"

  assume_role_policy = "${file("assume-role-policy.json")}"
}

resource "aws_iam_role_policy" "ecs_service" {
  name = "nodejs_ecs_policy"
  role = "${aws_iam_role.ecs_service.name}"
  policy = "${file("nodejs_ecs_policy.json")}"
}

resource "aws_iam_instance_profile" "app" {
  name = "nj-ecs-instprofile"
  role = "${aws_iam_role.app_instance.name}"
}


resource "aws_iam_role" "app_instance" {
  name = "nj-ecs-instance-role"

  assume_role_policy = "${file("assume-role-policy.json")}"
}

data "template_file" "instance_profile" {
  template = "${file("${path.module}/instance-profile-policy.json")}"

  vars {
    app_log_group_arn = "${var.app_log_group_arn}"
    ecs_log_group_arn = "${var.ecs_log_group_arn}"
  }
}

resource "aws_iam_role_policy" "instance" {
  name   = "NjEcsInstanceRole"
  role   = "${aws_iam_role.app_instance.name}"
  policy = "${data.template_file.instance_profile.rendered}"
}






