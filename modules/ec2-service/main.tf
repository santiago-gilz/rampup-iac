module "asg" {
  name    = "sgilz-api-asg"
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  # Launch config
  create_lc          = true
  image_id           = var.AMI_ID
  instance_type      = var.AWS_INSTANCE_TYPE
  key_name           = var.AWS_KEY_PAIR_NAME
  lc_name            = "api-conf-"
  lc_use_name_prefix = true # uses lc_name as name_prefix
  security_groups    = var.security_groups
  use_lc             = true

  # ASG config
  min_size                  = var.ag_capacities["min_size"]
  max_size                  = var.ag_capacities["max_size"]
  desired_capacity          = var.ag_capacities["desired_capacity"]
  wait_for_capacity_timeout = var.ag_capacities["wait_for_capacity_timeout"]
  health_check_type         = "EC2"
  health_check_grace_period = 360 # 6 mins until next healt check
  vpc_zone_identifier       = var.vpc_zone_identifier
  force_delete              = true

  #Provision
  user_data = templatefile(
    "./templates/provision.sh.tpl",
    {
      "TARGET_APP" = var.target_app
      "API_LB_IP"  = var.api_lb_ip
    }
  )

  tags = [
    for tag_key, tag_value in var.tags :
    {
      key                 = tag_key
      value               = tag_value
      propagate_at_launch = true
    }
  ]
}
