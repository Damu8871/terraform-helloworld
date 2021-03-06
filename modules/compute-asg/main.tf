resource "aws_autoscaling_group" "app" {
  name                 = "${var.aws_autoscaling_group_name}"
  vpc_zone_identifier  = ["${var.private_subnet_ids}"]
  min_size             = "${var.asg_min}"
  max_size             = "${var.asg_max}"
  desired_capacity     = "${var.asg_desired}"
  launch_configuration = "${aws_launch_configuration.app.name}"
}

data "template_file" "cloud_config" {
  template = "${file("${path.module}/cloud-config.yml")}"

  vars {
    aws_region         = "${var.aws_region}"
    ecs_cluster_name   = "${var.cluster_name}"
    ecs_log_level      = "info"
    ecs_agent_version  = "latest"
    ecs_log_group_name = "${var.ecs_log_group_name}"
  }
}

data "aws_ami" "stable_coreos" {
  most_recent = true

  filter {
    name   = "description"
    values = ["CoreOS Container Linux stable *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["042827707937"] # CoreOS
}

resource "aws_launch_configuration" "app" {
  security_groups = [
    "${var.instance_sg}",
  ]

  key_name                    = "${var.key_name}"
  image_id                    = "${data.aws_ami.stable_coreos.id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${var.instance_profile_name}"
  user_data                   = "${data.template_file.cloud_config.rendered}"
  associate_public_ip_address = false
  
  lifecycle {
    create_before_destroy = true
  }
}


