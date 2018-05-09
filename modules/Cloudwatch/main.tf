resource "aws_cloudwatch_log_group" "ecs" {
  name = "${var.ecsagent_log_name}"
}

resource "aws_cloudwatch_log_group" "app" {
  name = "${var.hellonode_app_log_name}"
}
