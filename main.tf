locals {
  api_elb_name = "api-elb"
  ui_elb_name = "ui-elb"
}

resource "aws_instance" "bastion" {
  ami               = data.aws_ami.centos8.id
  availability_zone = "${var.AWS_REGION}a"
  instance_type     = var.AWS_INSTANCE_TYPE
  key_name          = var.AWS_KEY_PAIR_NAME
  security_groups   = [aws_security_group.bastion_sg.id]
  subnet_id         = var.existing_resources["public_subnet_0_id"]

  tags = merge(
    var.common_tags,
    {
      Name = "sgilz-bastion"
    }
  )

  volume_tags = var.common_tags
}

module "ui_elb" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 2.0"

  internal        = false
  name            = local.ui_elb_name
  security_groups = [aws_security_group.ui_lb_sg.id]
  subnets         = [var.existing_resources["public_subnet_0_id"], var.existing_resources["public_subnet_1_id"]]

  health_check = {
    target              = "HTTP:${var.access_ports["ui"]}/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  listener = [
    {
      instance_port     = var.access_ports["ui"]
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    },
  ]

  tags = merge(
    var.common_tags,
    {
      "Name" = "sgilz-ui-autoscaling-group-LB"
    },
  )
}

module "api_elb" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 2.0"

  internal        = true
  name            = local.api_elb_name
  security_groups = [aws_security_group.api_lb_sg.id]
  subnets         = [var.existing_resources["private_subnet_0_id"], var.existing_resources["private_subnet_1_id"]]

  health_check = {
    target              = "HTTP:${var.access_ports["api"]}/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  listener = [
    {
      instance_port     = var.access_ports["api"]
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    },
  ]

  tags = merge(
    var.common_tags,
    {
      "Name" = "api-autoscaling-group-LB"
    },
  )
}

module "ui_asg" {
  source = "./modules/ec2-service"
  name   = "sgilz-ui-asg"

  AMI_ID            = data.aws_ami.centos8.id
  AWS_INSTANCE_TYPE = var.AWS_INSTANCE_TYPE
  AWS_KEY_PAIR_NAME = var.AWS_KEY_PAIR_NAME
  api_lb_ip = module.api_elb.elb_dns_name
  ag_capacities = {
    "min_size"                  = 1
    "max_size"                  = 3
    "desired_capacity"          = 2
    "wait_for_capacity_timeout" = 0
  }
  lb_name             = local.ui_elb_name
  security_groups     = [aws_security_group.ui_sg.id]
  tags                = var.common_tags
  target_app          = "ui"
  vpc_zone_identifier = [var.existing_resources["private_subnet_0_id"], var.existing_resources["private_subnet_1_id"]]
}

module "api_asg" {
  source = "./modules/ec2-service"
  name   = "sgilz-api-asg"

  AMI_ID            = data.aws_ami.centos8.id
  API_ACCESS_PORT   = var.access_ports["api"]
  AWS_INSTANCE_TYPE = var.AWS_INSTANCE_TYPE
  AWS_KEY_PAIR_NAME = var.AWS_KEY_PAIR_NAME
  ag_capacities = {
    "min_size"                  = 1
    "max_size"                  = 3
    "desired_capacity"          = 2
    "wait_for_capacity_timeout" = 0
  }
  lb_name             = local.api_elb_name
  security_groups     = [aws_security_group.api_sg.id]
  tags                = var.common_tags
  target_app          = "api"
  vpc_zone_identifier = [var.existing_resources["private_subnet_0_id"], var.existing_resources["private_subnet_1_id"]]
}
