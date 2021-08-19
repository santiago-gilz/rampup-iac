module "asg" {
  name    = var.name
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
  health_check_type         = "ELB"
  health_check_grace_period = 360 # 6 mins until next healt check
  load_balancers            = [var.lb_name]
  vpc_zone_identifier       = var.vpc_zone_identifier
  force_delete              = true

  #Provision cancelled since it is done in the sys config management.
  /* user_data = templatefile(
    "./modules/ec2-service/templates/provision.sh.tpl",
    {
      "TARGET_APP"      = var.target_app
      "API_LB_IP"       = var.api_lb_ip
      "API_ACCESS_PORT" = var.API_ACCESS_PORT
    }
  ) */
  user_data = templatefile(
    "./modules/ec2-service/templates/run_ansible.sh.tpl",
    {
      "extra_vars" = jsonencode(
        {
          "api_lb_ip"       = var.api_lb_ip
          "api_access_port" = var.API_ACCESS_PORT
        }
      )
      "TARGET_APP"     = var.target_app
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
