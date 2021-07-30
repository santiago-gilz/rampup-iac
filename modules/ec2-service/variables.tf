variable "AMI_ID" {
  type        = string
  description = "AMI ID to use into the AG (Autoscaling group)"
}

variable "API_ACCESS_PORT" {
  type        = string
  description = "Port from where the api will be accessed"
  default     = "3000"
}

variable "AWS_INSTANCE_TYPE" {
  type        = string
  description = "The Amazon AWS instance type to used into the AG"
}

variable "AWS_KEY_PAIR_NAME" {
  type = string
}

variable "ag_capacities" {
  type        = map(number)
  description = "A map with the desired sizes for the AG"
  default = {
    "min_size"                  = 1
    "max_size"                  = 3
    "desired_capacity"          = 2
    "wait_for_capacity_timeout" = 0
  }
}

variable "target_app" {
  type        = string
  description = "Whether to provison api or ui app. Allowed: ui, api"
}

variable "api_lb_ip" {
  type        = string
  description = "IP of the api LB only when the ui will be launched"
  default     = ""
}

variable "lb_name" {
  type        = string
  description = "Name of the Load balancer to attach the AG"
}

variable "name" {
  type        = string
  description = "Name to put on the created resources"
  default     = "sgilz-asg"
}

variable "tags" {
  type        = map(string)
  description = "Tags to use into the AG and its instances"
}

variable "security_groups" {
  type        = list(string)
  description = "A list with seg-group IDs to add the AG instances to"
}

variable "vpc_zone_identifier" {
  type        = list(string)
  description = "A list with the needed subnets for the AG"
}
