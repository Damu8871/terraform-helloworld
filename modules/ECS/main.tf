resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.clustername}"
}

data "template_file" "task_def" {
  template = "${file("${path.module}/task-definition.json")}"

  vars {
  image_url = "${var.image_url}"
  container_name = "${var.container_name}"
  log_group_region = "${var.cluster_region}"
  log_group_name = "${var.log_group_name}"	
  }
}

resource "aws_ecs_task_definition" "hellonode" {
  family                = "${var.task-def-family}"
  container_definitions = "${data.template_file.task_def.rendered}"
}


resource "aws_ecs_service" "test" {
  name            = "${var.ecs_service_name}"
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.hellonode.arn}"
  desired_count   = 1
  iam_role        = "${var.iam_role_for_ecs}"

  load_balancer {
    target_group_arn = "${var.alb_target_group_id}"
    container_name   = "${var.container_name}"
    container_port   = "8080"
  }

  depends_on = [
   "${var.iam_role_policy_name}",
  ]
}
